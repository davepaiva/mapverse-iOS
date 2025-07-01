import SwiftUI

struct ExpandableCard: View {
    let title: String
    let value: String
    let alignment: Alignment
    let onLongPress: (() -> Void)? // Optional long press action
    

    @State private var isExpanded = false
    
    init(title: String, value: String, alignment: Alignment = .leading, onLongPress: (() -> Void)? = nil) {
        self.title = title
        self.value = value
        self.alignment = alignment
        self.onLongPress = onLongPress
        self.doesNeedExpansion = value.count > 10 || value.contains("\n")
    }
    
    private var doesNeedExpansion: Bool
    
    private var horizonatlAlignment: HorizontalAlignment {
        switch alignment {
        case .leading:
            return .leading
        case .center:
            return .center
        case .trailing:
            return .trailing
        default:
            fatalError()
        }
    }


    var body: some View {
        VStack(alignment: horizonatlAlignment, spacing: 4){
            HStack{
                Text(title)
                    .foregroundColor(.gray)
                    .font(.subheadline)
                
                if doesNeedExpansion{
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up": "chevron.down")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .frame(maxWidth: .infinity, alignment: alignment)
            
            Text(value)
                .font(.body)
                .lineLimit(isExpanded ? nil : 1 )
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .onTapGesture{
            if doesNeedExpansion{
                withAnimation(.easeInOut(duration: 0.2)){
                    isExpanded.toggle()
                }
            }
        }
        .onLongPressGesture {
            onLongPress?()
        }
    
        
    }
}


#Preview{
    ExpandableCard(
        title: "This is a test", 
        value: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.", 
        alignment: .leading,
        onLongPress: {
            print("Long pressed!")
        }
    )
}
