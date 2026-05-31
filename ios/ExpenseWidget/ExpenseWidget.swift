import WidgetKit
import SwiftUI
import AppIntents

@available(iOS 17.0, *)
enum WidgetExpenseViewType: String, AppEnum {
    case recentExpenses = "recentExpenses"
    case topTags = "topTags"
    case topCategories = "topCategories"

    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Expense View Type"

    static var caseDisplayRepresentations: [WidgetExpenseViewType : DisplayRepresentation] = [
        .recentExpenses: DisplayRepresentation(title: "Recent Expenses"),
        .topTags: DisplayRepresentation(title: "Top Tags"),
        .topCategories: DisplayRepresentation(title: "Top Categories")
    ]
}

@available(iOS 17.0, *)
struct SelectOrganizationIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Select Organization"
    static var description = IntentDescription("Choose which organization's data to display.")

    @Parameter(title: "Organization", optionsProvider: OrganizationOptionsProvider())
    var organization: WidgetOrganizationEntity?

    @Parameter(title: "Expense Display", default: .recentExpenses)
    var expenseViewType: WidgetExpenseViewType

    @Parameter(title: "Show Accounts", default: true)
    var showAccounts: Bool

    @Parameter(title: "Show Monthly Summary", default: true)
    var showMonthlySummary: Bool

    func perform() async throws -> some IntentResult {
        return .result()
    }
}

@available(iOS 17.0, *)
struct WidgetOrganizationEntity: AppEntity, Identifiable {
    let id: String
    let name: String

    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Organization"
    static var defaultQuery = OrganizationQuery()

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(name)")
    }
}

@available(iOS 17.0, *)
struct OrganizationOptionsProvider: DynamicOptionsProvider {
    func results() async throws -> [WidgetOrganizationEntity] {
        let data = readOrganizationsFromUserDefaults()
        return data.map { WidgetOrganizationEntity(id: $0.id, name: $0.name) }
    }
    
    func defaultResult() async -> WidgetOrganizationEntity? {
        return nil
    }
}

@available(iOS 17.0, *)
struct OrganizationQuery: EntityQuery {
    func entities(for identifiers: [WidgetOrganizationEntity.ID]) async throws -> [WidgetOrganizationEntity] {
        let data = readOrganizationsFromUserDefaults()
        return data
            .filter { identifiers.contains($0.id) }
            .map { WidgetOrganizationEntity(id: $0.id, name: $0.name) }
    }

    func suggestedEntities() async throws -> [WidgetOrganizationEntity] {
        let data = readOrganizationsFromUserDefaults()
        return data.map { WidgetOrganizationEntity(id: $0.id, name: $0.name) }
    }
}

struct SharedOrgData: Codable {
    let id: String
    let name: String
}

func readOrganizationsFromUserDefaults() -> [SharedOrgData] {
    guard let defaults = UserDefaults(suiteName: "group.com.expenseflow.app"),
          let jsonString = defaults.string(forKey: "widget_organizations_data"),
          let data = jsonString.data(using: .utf8) else {
        return [SharedOrgData(id: "personal", name: "Personal")]
    }
    do {
        return try JSONDecoder().decode([SharedOrgData].self, from: data)
    } catch {
        return [SharedOrgData(id: "personal", name: "Personal")]
    }
}

// MARK: - Widget Data Structures

struct WidgetNamedAmount: Codable {
    let name: String
    let amount: String
}

struct WidgetData: Codable {
    let activeOrgName: String
    let activeOrgId: String
    let totalBalance: String
    let monthlyIncome: String?
    let monthlyExpense: String?
    let accounts: [WidgetAccount]
    let recentExpenses: [WidgetExpense]
    let topTags: [WidgetNamedAmount]?
    let expensesByCategory: [WidgetNamedAmount]?

    var safeMonthlyIncome: String { monthlyIncome ?? "$0.00" }
    var safeMonthlyExpense: String { monthlyExpense ?? "$0.00" }
    var safeTopTags: [WidgetNamedAmount] { topTags ?? [] }
    var safeExpensesByCategory: [WidgetNamedAmount] { expensesByCategory ?? [] }

    static var placeholder: WidgetData {
        WidgetData(
            activeOrgName: "Personal",
            activeOrgId: "personal",
            totalBalance: "$12,450.00",
            monthlyIncome: "$8,200.00",
            monthlyExpense: "$3,450.00",
            accounts: [
                WidgetAccount(name: "Chase Checking", balance: "$8,500.00"),
                WidgetAccount(name: "Savings", balance: "$3,950.00")
            ],
            recentExpenses: [
                WidgetExpense(description: "Stripe Payout", amount: "-$34.50", date: "May 28"),
                WidgetExpense(description: "AWS Cloud Services", amount: "-$120.00", date: "May 27"),
                WidgetExpense(description: "GitHub Copilot", amount: "-$10.00", date: "May 26")
            ],
            topTags: [
                WidgetNamedAmount(name: "SaaS", amount: "-$130.00"),
                WidgetNamedAmount(name: "Meals", amount: "-$45.20"),
                WidgetNamedAmount(name: "Travel", amount: "-$320.00")
            ],
            expensesByCategory: [
                WidgetNamedAmount(name: "Software", amount: "-$130.00"),
                WidgetNamedAmount(name: "Food", amount: "-$45.20"),
                WidgetNamedAmount(name: "Transport", amount: "-$320.00")
            ]
        )
    }
}

struct WidgetAccount: Codable {
    let name: String
    let balance: String
}

struct WidgetExpense: Codable {
    let description: String
    let amount: String
    let date: String
}

@available(iOS 17.0, *)
func readWidgetData(for selectedOrg: WidgetOrganizationEntity?) -> WidgetData {
    guard let defaults = UserDefaults(suiteName: "group.com.expenseflow.app") else {
        return WidgetData.placeholder
    }
    
    if let selected = selectedOrg {
        let key = "widget_data_\(selected.id)"
        if let jsonString = defaults.string(forKey: key),
           let data = jsonString.data(using: .utf8) {
            do {
                return try JSONDecoder().decode(WidgetData.self, from: data)
            } catch {}
        }
        
        // Specific org selected, but data is missing -> return empty values for this org
        return WidgetData(
            activeOrgName: selected.name,
            activeOrgId: selected.id,
            totalBalance: "$0.00",
            monthlyIncome: "$0.00",
            monthlyExpense: "$0.00",
            accounts: [],
            recentExpenses: [],
            topTags: [],
            expensesByCategory: []
        )
    } else {
        let key = "widget_data"
        if let jsonString = defaults.string(forKey: key),
           let data = jsonString.data(using: .utf8) {
            do {
                return try JSONDecoder().decode(WidgetData.self, from: data)
            } catch {}
        }
        return WidgetData.placeholder
    }
}

// MARK: - Widget Timeline Provider

@available(iOS 17.0, *)
struct WidgetTimelineProvider: AppIntentTimelineProvider {
    typealias Entry = SimpleEntry
    typealias Intent = SelectOrganizationIntent

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(
            date: Date(),
            data: WidgetData.placeholder,
            showAccounts: true,
            showMonthlySummary: true,
            expenseViewType: .recentExpenses
        )
    }

    func snapshot(for intent: SelectOrganizationIntent, in context: Context) async -> SimpleEntry {
        let data = readWidgetData(for: intent.organization)
        return SimpleEntry(
            date: Date(),
            data: data,
            showAccounts: intent.showAccounts,
            showMonthlySummary: intent.showMonthlySummary,
            expenseViewType: intent.expenseViewType
        )
    }

    func timeline(for intent: SelectOrganizationIntent, in context: Context) async -> Timeline<SimpleEntry> {
        let data = readWidgetData(for: intent.organization)
        let entry = SimpleEntry(
            date: Date(),
            data: data,
            showAccounts: intent.showAccounts,
            showMonthlySummary: intent.showMonthlySummary,
            expenseViewType: intent.expenseViewType
        )
        // Refresh timeline every 15 minutes
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 15, to: Date())!
        return Timeline(entries: [entry], policy: .after(nextUpdate))
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let data: WidgetData
    let showAccounts: Bool
    let showMonthlySummary: Bool
    let expenseViewType: WidgetExpenseViewType
}

// MARK: - SwiftUI Views

struct ExpenseWidgetEntryView: View {
    var entry: SimpleEntry
    @Environment(\.widgetFamily) var family

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if family == .systemSmall {
                SmallWidgetView(
                    data: entry.data,
                    showAccounts: entry.showAccounts,
                    showMonthlySummary: entry.showMonthlySummary,
                    expenseViewType: entry.expenseViewType
                )
            } else if family == .systemMedium {
                MediumWidgetView(
                    data: entry.data,
                    showAccounts: entry.showAccounts,
                    showMonthlySummary: entry.showMonthlySummary,
                    expenseViewType: entry.expenseViewType
                )
            } else {
                LargeWidgetView(
                    data: entry.data,
                    showAccounts: entry.showAccounts,
                    showMonthlySummary: entry.showMonthlySummary,
                    expenseViewType: entry.expenseViewType
                )
            }
        }
        .padding(14)
        .containerBackground(Color.black, for: .widget)
    }
}

struct SmallWidgetView: View {
    let data: WidgetData
    let showAccounts: Bool
    let showMonthlySummary: Bool
    let expenseViewType: WidgetExpenseViewType

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            // Header: Org name
            HStack(spacing: 4) {
                Circle()
                    .fill(Color(red: 0.39, green: 0.36, blue: 1.0)) // Stripe Indigo
                    .frame(width: 6, height: 6)
                Text(data.activeOrgName)
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
            
            Spacer()

            // Balance
            VStack(alignment: .leading, spacing: 1) {
                Text("Total Balance")
                    .font(.system(size: 10, weight: .medium, design: .rounded))
                    .foregroundColor(.gray)
                Text(data.totalBalance)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .minimumScaleFactor(0.7)
                    .lineLimit(1)
            }

            Spacer()

            // Sub-accounts or monthly summary
            if showMonthlySummary {
                HStack(spacing: 8) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("IN")
                            .font(.system(size: 7, weight: .bold))
                            .foregroundColor(.gray)
                        Text(data.safeMonthlyIncome)
                            .font(.system(size: 10, weight: .bold, design: .rounded))
                            .foregroundColor(.green)
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                    }
                    VStack(alignment: .leading, spacing: 0) {
                        Text("OUT")
                            .font(.system(size: 7, weight: .bold))
                            .foregroundColor(.gray)
                        Text(data.safeMonthlyExpense)
                            .font(.system(size: 10, weight: .bold, design: .rounded))
                            .foregroundColor(.red)
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                    }
                }
            } else if showAccounts, let firstAccount = data.accounts.first {
                HStack {
                    Text(firstAccount.name)
                        .font(.system(size: 9))
                        .foregroundColor(.gray)
                        .lineLimit(1)
                    Spacer()
                    Text(firstAccount.balance)
                        .font(.system(size: 9, weight: .bold))
                        .foregroundColor(.white)
                }
            } else {
                if expenseViewType == .recentExpenses, let firstExp = data.recentExpenses.first {
                    HStack {
                        Text(firstExp.description)
                            .font(.system(size: 9))
                            .foregroundColor(.gray)
                            .lineLimit(1)
                        Spacer()
                        Text(firstExp.amount)
                            .font(.system(size: 9, weight: .bold))
                            .foregroundColor(Color(red: 1.0, green: 0.28, blue: 0.36))
                    }
                } else if expenseViewType == .topTags, let firstTag = data.safeTopTags.first {
                    HStack {
                        Text(firstTag.name)
                            .font(.system(size: 9))
                            .foregroundColor(.gray)
                            .lineLimit(1)
                        Spacer()
                        Text(firstTag.amount)
                            .font(.system(size: 9, weight: .bold))
                            .foregroundColor(Color(red: 1.0, green: 0.28, blue: 0.36))
                    }
                } else if expenseViewType == .topCategories, let firstCat = data.safeExpensesByCategory.first {
                    HStack {
                        Text(firstCat.name)
                            .font(.system(size: 9))
                            .foregroundColor(.gray)
                            .lineLimit(1)
                        Spacer()
                        Text(firstCat.amount)
                            .font(.system(size: 9, weight: .bold))
                            .foregroundColor(Color(red: 1.0, green: 0.28, blue: 0.36))
                    }
                }
            }
        }
    }
}

struct MediumWidgetView: View {
    let data: WidgetData
    let showAccounts: Bool
    let showMonthlySummary: Bool
    let expenseViewType: WidgetExpenseViewType

    var title: String {
        switch expenseViewType {
        case .recentExpenses: return "Recent Expenses"
        case .topTags: return "Top Tags"
        case .topCategories: return "Top Categories"
        }
    }

    var body: some View {
        HStack(spacing: 12) {
            // Left Column: Account Details / Monthly Summary
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 5) {
                    Circle()
                        .fill(Color(red: 0.39, green: 0.36, blue: 1.0)) // Stripe Indigo
                        .frame(width: 8, height: 8)
                    Text(data.activeOrgName)
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .lineLimit(1)
                }
                
                Spacer()

                VStack(alignment: .leading, spacing: 1) {
                    Text("Total Balance")
                        .font(.system(size: 10, weight: .medium, design: .rounded))
                        .foregroundColor(.gray)
                    Text(data.totalBalance)
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .minimumScaleFactor(0.8)
                        .lineLimit(1)
                }

                Spacer()
                
                if showMonthlySummary {
                    HStack(spacing: 12) {
                        VStack(alignment: .leading, spacing: 1) {
                            Text("IN")
                                .font(.system(size: 7, weight: .bold))
                                .foregroundColor(.gray)
                            Text(data.safeMonthlyIncome)
                                .font(.system(size: 12, weight: .bold, design: .rounded))
                                .foregroundColor(.green)
                        }
                        VStack(alignment: .leading, spacing: 1) {
                            Text("OUT")
                                .font(.system(size: 7, weight: .bold))
                                .foregroundColor(.gray)
                            Text(data.safeMonthlyExpense)
                                .font(.system(size: 12, weight: .bold, design: .rounded))
                                .foregroundColor(.red)
                        }
                    }
                    
                    if showAccounts, let firstAcc = data.accounts.first {
                        Spacer().frame(height: 4)
                        HStack {
                            Text(firstAcc.name)
                                .font(.system(size: 9))
                                .foregroundColor(.gray)
                                .lineLimit(1)
                            Spacer()
                            Text(firstAcc.balance)
                                .font(.system(size: 9, weight: .semibold))
                                .foregroundColor(.white)
                        }
                    }
                } else if showAccounts {
                    // Show accounts if available
                    VStack(alignment: .leading, spacing: 3) {
                        ForEach(data.accounts.prefix(2), id: \.name) { acc in
                            HStack {
                                Text(acc.name)
                                    .font(.system(size: 9))
                                    .foregroundColor(.gray)
                                    .lineLimit(1)
                                Spacer()
                                Text(acc.balance)
                                    .font(.system(size: 9, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            // Vertical divider
            Rectangle()
                .fill(Color.white.opacity(0.1))
                .frame(width: 1)
                .padding(.vertical, 4)

            // Right Column: Dynamic expense lists (recent, tags, categories)
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.system(size: 10, weight: .bold, design: .rounded))
                    .foregroundColor(.gray)

                if expenseViewType == .recentExpenses {
                    if data.recentExpenses.isEmpty {
                        Spacer()
                        Text("No recent expenses")
                            .font(.system(size: 11))
                            .foregroundColor(.gray)
                            .italic()
                        Spacer()
                    } else {
                        ForEach(data.recentExpenses.prefix(3), id: \.description) { exp in
                            HStack(spacing: 4) {
                                VStack(alignment: .leading, spacing: 0) {
                                    Text(exp.description)
                                        .font(.system(size: 11, weight: .medium))
                                        .foregroundColor(.white)
                                        .lineLimit(1)
                                    Text(exp.date)
                                        .font(.system(size: 8))
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()

                                Text(exp.amount)
                                    .font(.system(size: 11, weight: .bold, design: .rounded))
                                    .foregroundColor(Color(red: 1.0, green: 0.28, blue: 0.36))
                            }
                        }
                    }
                } else if expenseViewType == .topTags {
                    if data.safeTopTags.isEmpty {
                        Spacer()
                        Text("No tags found")
                            .font(.system(size: 11))
                            .foregroundColor(.gray)
                            .italic()
                        Spacer()
                    } else {
                        ForEach(data.safeTopTags.prefix(3), id: \.name) { tag in
                            HStack(spacing: 4) {
                                Text(tag.name)
                                    .font(.system(size: 11, weight: .medium))
                                    .foregroundColor(.white)
                                    .lineLimit(1)
                                Spacer()
                                Text(tag.amount)
                                    .font(.system(size: 11, weight: .bold, design: .rounded))
                                    .foregroundColor(Color(red: 1.0, green: 0.28, blue: 0.36))
                            }
                        }
                    }
                } else {
                    if data.safeExpensesByCategory.isEmpty {
                        Spacer()
                        Text("No categories found")
                            .font(.system(size: 11))
                            .foregroundColor(.gray)
                            .italic()
                        Spacer()
                    } else {
                        ForEach(data.safeExpensesByCategory.prefix(3), id: \.name) { cat in
                            HStack(spacing: 4) {
                                Text(cat.name)
                                    .font(.system(size: 11, weight: .medium))
                                    .foregroundColor(.white)
                                    .lineLimit(1)
                                Spacer()
                                Text(cat.amount)
                                    .font(.system(size: 11, weight: .bold, design: .rounded))
                                    .foregroundColor(Color(red: 1.0, green: 0.28, blue: 0.36))
                            }
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct LargeWidgetView: View {
    let data: WidgetData
    let showAccounts: Bool
    let showMonthlySummary: Bool
    let expenseViewType: WidgetExpenseViewType

    var title: String {
        switch expenseViewType {
        case .recentExpenses: return "Recent Expenses"
        case .topTags: return "Top Tags"
        case .topCategories: return "Top Categories"
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Header: Org name and Total Balance
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 3) {
                    HStack(spacing: 5) {
                        Circle()
                            .fill(Color(red: 0.39, green: 0.36, blue: 1.0)) // Stripe Indigo
                            .frame(width: 8, height: 8)
                        Text(data.activeOrgName)
                            .font(.system(size: 13, weight: .bold, design: .rounded))
                            .foregroundColor(.gray)
                            .lineLimit(1)
                    }
                    Text(data.totalBalance)
                        .font(.system(size: 26, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .lineLimit(1)
                }
                Spacer()
            }
            
            // Monthly Summary Card
            if showMonthlySummary {
                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("MONTHLY INCOME")
                            .font(.system(size: 8, weight: .bold))
                            .foregroundColor(.gray)
                        Text(data.safeMonthlyIncome)
                            .font(.system(size: 15, weight: .bold, design: .rounded))
                            .foregroundColor(.green)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(8)
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(8)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("MONTHLY EXPENSE")
                            .font(.system(size: 8, weight: .bold))
                            .foregroundColor(.gray)
                        Text(data.safeMonthlyExpense)
                            .font(.system(size: 15, weight: .bold, design: .rounded))
                            .foregroundColor(.red)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(8)
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(8)
                }
            }
            
            // Accounts Section
            if showAccounts && !data.accounts.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Accounts")
                        .font(.system(size: 10, weight: .bold, design: .rounded))
                        .foregroundColor(.gray)
                    
                    ForEach(data.accounts.prefix(3), id: \.name) { acc in
                        HStack {
                            Text(acc.name)
                                .font(.system(size: 11))
                                .foregroundColor(.white.opacity(0.8))
                                .lineLimit(1)
                            Spacer()
                            Text(acc.balance)
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                }
            }
            
            Divider()
                .background(Color.white.opacity(0.1))
            
            // Bottom list: Recent Expenses / Tags / Categories
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .foregroundColor(.gray)
                
                if expenseViewType == .recentExpenses {
                    if data.recentExpenses.isEmpty {
                        Text("No recent expenses")
                            .font(.system(size: 11))
                            .foregroundColor(.gray)
                            .italic()
                            .padding(.top, 4)
                    } else {
                        VStack(spacing: 5) {
                            ForEach(data.recentExpenses.prefix(4), id: \.description) { exp in
                                HStack {
                                    VStack(alignment: .leading, spacing: 1) {
                                        Text(exp.description)
                                            .font(.system(size: 12, weight: .medium))
                                            .foregroundColor(.white)
                                            .lineLimit(1)
                                        Text(exp.date)
                                            .font(.system(size: 8))
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                    Text(exp.amount)
                                        .font(.system(size: 12, weight: .bold, design: .rounded))
                                        .foregroundColor(Color(red: 1.0, green: 0.28, blue: 0.36))
                                }
                            }
                        }
                    }
                } else if expenseViewType == .topTags {
                    if data.safeTopTags.isEmpty {
                        Text("No tags found")
                            .font(.system(size: 11))
                            .foregroundColor(.gray)
                            .italic()
                            .padding(.top, 4)
                    } else {
                        VStack(spacing: 5) {
                            ForEach(data.safeTopTags.prefix(4), id: \.name) { tag in
                                HStack {
                                    Text(tag.name)
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(.white)
                                        .lineLimit(1)
                                    Spacer()
                                    Text(tag.amount)
                                        .font(.system(size: 12, weight: .bold, design: .rounded))
                                        .foregroundColor(Color(red: 1.0, green: 0.28, blue: 0.36))
                                }
                            }
                        }
                    }
                } else {
                    if data.safeExpensesByCategory.isEmpty {
                        Text("No categories found")
                            .font(.system(size: 11))
                            .foregroundColor(.gray)
                            .italic()
                            .padding(.top, 4)
                    } else {
                        VStack(spacing: 5) {
                            ForEach(data.safeExpensesByCategory.prefix(4), id: \.name) { cat in
                                HStack {
                                    Text(cat.name)
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(.white)
                                        .lineLimit(1)
                                    Spacer()
                                    Text(cat.amount)
                                        .font(.system(size: 12, weight: .bold, design: .rounded))
                                        .foregroundColor(Color(red: 1.0, green: 0.28, blue: 0.36))
                                }
                            }
                        }
                    }
                }
            }
            
            Spacer()
        }
    }
}

// MARK: - Widget Base Definition

@main
@available(iOS 17.0, *)
struct ExpenseWidget: Widget {
    let kind: String = "ExpenseWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: SelectOrganizationIntent.self,
            provider: WidgetTimelineProvider()
        ) { entry in
            ExpenseWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("ExpenseFlow Overview")
        .description("View active organization balance, account breakdowns, and recent expenses.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
        .contentMarginsDisabled()
    }
}
