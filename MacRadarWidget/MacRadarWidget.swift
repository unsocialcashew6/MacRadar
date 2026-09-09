import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), ram: "0.0 GB", disk: "0.0 GB", cpu: "0.0%", cpuVal: 0.0, ramVal: 0.0, diskVal: 0.0)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), ram: "8.0 GB", disk: "120.0 GB", cpu: "15.0%", cpuVal: 0.15, ramVal: 0.5, diskVal: 0.4)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let sharedDefaults = UserDefaults(suiteName: "group.com.unsocialcashew6.MacRadar")
        
        let currentRAM = sharedDefaults?.string(forKey: "shared_ram") ?? "Counting RAM..."
        let currentDisk = sharedDefaults?.string(forKey: "shared_disk") ?? "Counting Disk..."
        let currentCPU = sharedDefaults?.string(forKey: "shared_cpu") ?? "0.0%"
        
        let rawCpu = sharedDefaults?.float(forKey: "shared_cpu_val") ?? 0.0
        let rawRam = sharedDefaults?.float(forKey: "shared_ram_val") ?? 0.0
        let rawDisk = sharedDefaults?.float(forKey: "shared_disk_val") ?? 0.0
        
        let cpuVal = Double(rawCpu)
        let ramVal = Double(rawRam)
        let diskVal = Double(rawDisk)
        
        let entry = SimpleEntry(date: Date(), ram: currentRAM, disk: currentDisk, cpu: currentCPU, cpuVal: cpuVal, ramVal: ramVal, diskVal: diskVal)
        
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }
}


struct SimpleEntry: TimelineEntry {
    let date: Date
    let ram: String
    let disk: String
    let cpu: String
    let cpuVal: Double
    let ramVal: Double
    let diskVal: Double
}


struct MacRadarWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("MacRadar", systemImage: "gauge.medium")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.orange)
            
            Divider()
            
            
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Label("CPU", systemImage: "cpu")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(entry.cpu)
                        .font(.caption)
                        .fontWeight(.semibold)
                }
                ProgressView(value: entry.cpuVal)
                    .tint(entry.cpuVal > 0.85 ? .red : (entry.cpuVal > 0.65 ? .orange : .blue))
            }
            
            
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Label("RAM", systemImage: "memorychip")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(entry.ram.components(separatedBy: " / ").first ?? "")
                        .font(.caption)
                        .fontWeight(.semibold)
                }
                ProgressView(value: entry.ramVal)
                    .tint(entry.ramVal > 0.85 ? .red : (entry.ramVal > 0.65 ? .orange : .blue))
            }
            
            
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Label("Disk", systemImage: "internaldrive")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(entry.disk.components(separatedBy: " / ").first ?? "")
                        .font(.caption)
                }
                ProgressView(value: entry.diskVal)
                    .tint(.primary)
            }
        }
        .padding()
    }
}


struct MacRadarWidget: Widget {
    let kind: String = "MacRadarWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            MacRadarWidgetEntryView(entry: entry)
                .containerBackground(.thinMaterial, for: .widget)
        }
        .configurationDisplayName("MacRadar")
        .description("Shows CPU, RAM and disk usage with progress bars.")
        .supportedFamilies([.systemMedium])
    }
}

