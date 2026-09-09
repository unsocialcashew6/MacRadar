import SwiftUI
import WidgetKit
import ServiceManagement

@main
struct MacRadarApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @State private var ramInfo: String = "Counting RAM..."
    @State private var diskInfo: String = "Counting Disk..."
    @State private var cpuInfo: String = "Counting CPU..."
    
    @State private var cpuValue: Double = 0.0
    @State private var ramValue: Double = 0.0
    @State private var diskValue: Double = 0.0
    
    @State private var isLaunchAtLoginEnabled: Bool = false
    private let appService = SMAppService.mainApp
    
    @State private var hasPreviousTicks = false
    @State private var prevUser: UInt32 = 0
    @State private var prevSystem: UInt32 = 0
    @State private var prevIdle: UInt32 = 0
    @State private var prevNice: UInt32 = 0
    
    func formatGB(_ bytes: Int64) -> String {
        let gigabytes = Double(bytes) / 1024 / 1024 / 1024
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 1
        return (formatter.string(from: NSNumber(value: gigabytes)) ?? "0") + " GB"
    }

    func getDiskInfo() -> String {
        let fileManager = FileManager.default
        let path = NSHomeDirectory()
        do {
            let attributes = try fileManager.attributesOfFileSystem(forPath: path)
            if let freeBytes = attributes[.systemFreeSize] as? Int64,
               let totalBytes = attributes[.systemSize] as? Int64 {
                let usedBytes = totalBytes - freeBytes
                diskValue = Double(usedBytes) / Double(totalBytes)
                return "\(formatGB(freeBytes)) / \(formatGB(totalBytes))"
            }
        } catch { return "Read error" }
        return "Unknown"
    }
    
    func getRAMInfo() -> String {
        let totalMemoryInBytes = ProcessInfo.processInfo.physicalMemory
        var pageStats = vm_statistics64()
        var count = mach_msg_type_number_t(MemoryLayout<vm_statistics64>.size / MemoryLayout<integer_t>.size)
        
        let result = withUnsafeMutablePointer(to: &pageStats) {
            $0.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
                host_statistics64(mach_host_self(), HOST_VM_INFO64, $0, &count) // Вернули 64-битную структуру
            }
        }
        
        if result == KERN_SUCCESS {
            let pageSize = UInt64(vm_kernel_page_size)
            let activeMemory = UInt64(pageStats.active_count) * pageSize
            let wireMemory = UInt64(pageStats.wire_count) * pageSize
            let compressedMemory = UInt64(pageStats.speculative_count) * pageSize
            
            let usedBytes = Int64(activeMemory + wireMemory + compressedMemory)
            ramValue = Double(usedBytes) / Double(totalMemoryInBytes)
            
            return "\(formatGB(usedBytes)) / \(formatGB(Int64(totalMemoryInBytes)))"
        }
        return "Unknown"
    }


    func getCPUUsage() -> Double {
        var hostInfo = host_cpu_load_info()
        var count = mach_msg_type_number_t(MemoryLayout<host_cpu_load_info>.size / MemoryLayout<integer_t>.size)
        
        let result = withUnsafeMutablePointer(to: &hostInfo) {
            $0.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
                host_statistics(mach_host_self(), HOST_CPU_LOAD_INFO, $0, &count)
            }
        }
        
        if result == KERN_SUCCESS {
            let currentUser = hostInfo.cpu_ticks.0
            let currentSystem = hostInfo.cpu_ticks.1
            let currentIdle = hostInfo.cpu_ticks.2
            let currentNice = hostInfo.cpu_ticks.3
            
            if !hasPreviousTicks {
                prevUser = currentUser
                prevSystem = currentSystem
                prevIdle = currentIdle
                prevNice = currentNice
                hasPreviousTicks = true
                return 0.0
            }
            
            let userDiff = currentUser >= prevUser ? currentUser - prevUser : 0
            let systemDiff = currentSystem >= prevSystem ? currentSystem - prevSystem : 0
            let idleDiff = currentIdle >= prevIdle ? currentIdle - prevIdle : 0
            let niceDiff = currentNice >= prevNice ? currentNice - prevNice : 0
            
            prevUser = currentUser
            prevSystem = currentSystem
            prevIdle = currentIdle
            prevNice = currentNice
            
            let totalDiff = userDiff + systemDiff + idleDiff + niceDiff
            if totalDiff > 0 {
                let usedDiff = userDiff + systemDiff + niceDiff
                return Double(usedDiff) / Double(totalDiff)
            }
        }
        return 0.0
    }

    func updateStatsLoop() {
        let cpuRaw = getCPUUsage()
        cpuValue = cpuRaw
        cpuInfo = String(format: "%.1f%%", cpuRaw * 100.0)
        
        ramInfo = getRAMInfo()
        diskInfo = getDiskInfo()
        
        if let sharedDefaults = UserDefaults(suiteName: "group.com.unsocialcashew6.MacRadar") {
            sharedDefaults.set(ramInfo, forKey: "shared_ram")
            sharedDefaults.set(diskInfo, forKey: "shared_disk")
            sharedDefaults.set(cpuInfo, forKey: "shared_cpu")
            
            // ТОЧЕЧНО заменяем эти 3 строки (передаем как Float)
            sharedDefaults.set(Float(cpuValue), forKey: "shared_cpu_val")
            sharedDefaults.set(Float(ramValue), forKey: "shared_ram_val")
            sharedDefaults.set(Float(diskValue), forKey: "shared_disk_val")
        }
        
        WidgetCenter.shared.reloadAllTimelines()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            updateStatsLoop()
        }
    }

    
    func checkLaunchStatus() {
        isLaunchAtLoginEnabled = (appService.status == .enabled)
    }
    
    func toggleLaunchAtLogin(newValue: Bool) {
        do {
            if newValue { try appService.register() } else { try appService.unregister() }
        } catch { checkLaunchStatus() }
    }
    
    func colorForUsage(_ value: Double) -> Color {
        if value > 0.85 { return .red }
        if value > 0.65 { return .orange }
        return .blue
    }
    
    var body: some Scene {
        MenuBarExtra("MacRadar", systemImage: "gauge.medium") {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Image(systemName: "gauge.medium")
                        .font(.title2)
                        .foregroundColor(.orange)
                    Text("MacRadar")
                        .font(.headline)
                        .fontWeight(.bold)
                }
                .padding(.bottom, 2)
                
                Divider()
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Label("CPU Usage", systemImage: "cpu")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(cpuInfo)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                    ProgressView(value: cpuValue)
                        .tint(colorForUsage(cpuValue))
                        .animation(.linear(duration: 0.5), value: cpuValue)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Label("RAM (Used)", systemImage: "memorychip")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(ramInfo.components(separatedBy: " / ").first ?? "")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                    ProgressView(value: ramValue)
                        .tint(colorForUsage(ramValue))
                        .animation(.linear(duration: 0.5), value: ramValue)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Label("Disk (Filled)", systemImage: "internaldrive")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(diskInfo)
                            .font(.subheadline)
                    }
                    ProgressView(value: diskValue)
                        .tint(.primary)
                }
                
                Divider()
                
                Toggle("Launch at Login", isOn: Binding(
                    get: { isLaunchAtLoginEnabled },
                    set: { newValue in
                        isLaunchAtLoginEnabled = newValue
                        toggleLaunchAtLogin(newValue: newValue)
                    }
                ))
                .font(.footnote)
                .toggleStyle(.checkbox)
                
                Divider()
                
                Button(action: { NSApplication.shared.terminate(nil) }) {
                    HStack {
                        Image(systemName: "power")
                        Text("Quit MacRadar")
                    }
                    .frame(maxWidth: .infinity)
                }
                .keyboardShortcut("q")
            }
            .padding()
            .frame(width: 250)
            .onAppear {
                checkLaunchStatus()
                updateStatsLoop()
            }
        }
        .menuBarExtraStyle(.window)
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.prohibited)
    }
}
