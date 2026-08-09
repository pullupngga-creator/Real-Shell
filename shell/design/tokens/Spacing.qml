pragma Singleton
import QtQuick

/**
 * Real OS Spacing Tokens
 * 
 * Defines the spacing system for Real OS using a 4px base unit rhythm.
 * All spacing must use these tokens for consistency.
 * 
 * Architecture:
 * Component → Spacing Token → Actual Value
 * 
 * NEVER: Component → padding: 17
 */
QtObject {
    // Base Unit (4px rhythm)
    readonly property int base: 4
    
    // ========== SPACING SCALE ==========
    
    readonly property int xs: base * 1        // 4px
    readonly property int sm: base * 2        // 8px
    readonly property int md: base * 3        // 12px
    readonly property int lg: base * 4        // 16px
    readonly property int xl: base * 6        // 24px
    readonly property int xxl: base * 8       // 32px
    readonly property int xxxl: base * 12     // 48px
    
    // ========== COMPONENT-SPECIFIC SPACING ==========
    
    // Button spacing
    readonly property int buttonPadding: md
    readonly property int buttonPaddingSmall: sm
    readonly property int buttonPaddingLarge: lg
    readonly property int buttonGap: sm
    
    // Card spacing
    readonly property int cardPadding: lg
    readonly property int cardPaddingSmall: md
    readonly property int cardPaddingLarge: xl
    readonly property int cardGap: md
    
    // Panel spacing
    readonly property int panelPadding: md
    readonly property int panelPaddingCompact: sm
    readonly property int panelPaddingExpanded: lg
    readonly property int panelGap: md
    
    // Input spacing
    readonly property int inputPadding: md
    readonly property int inputPaddingSmall: sm
    readonly property int inputPaddingLarge: lg
    readonly property int inputGap: sm
    
    // List item spacing
    readonly property int listItemPadding: md
    readonly property int listItemPaddingSmall: sm
    readonly property int listItemPaddingLarge: lg
    readonly property int listItemGap: sm
    
    // Icon spacing
    readonly property int iconGap: sm
    readonly property int iconPadding: xs
    
    // Signal for spacing changes
    signal spacingChanged()
}
