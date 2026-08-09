pragma Singleton
import QtQuick

/**
 * Real OS Typography Tokens
 * 
 * Defines the complete typography hierarchy for Real OS.
 * All UI text must use these tokens for consistency.
 * 
 * Hierarchy:
 * - Display: Hero elements (21:30 clock, large numbers)
 * - Headline: Section headers, page titles
 * - Title: Card titles, panel headers
 * - Subtitle: Secondary titles, descriptions
 * - Body: Main content, paragraphs
 * - Label: Form labels, button text, small UI text
 * - Caption: Helper text, metadata
 * - Micro: Smallest text (timestamps, badges)
 * 
 * Each level has size variants (large, medium, small) where applicable.
 */
QtObject {
    // Font Family
    readonly property string fontFamily: "Inter, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif"
    readonly property string fontFamilyMono: "'JetBrains Mono', 'Fira Code', 'Cascadia Code', 'Consolas', 'Courier New', monospace"
    
    // Font Weights
    readonly property int weightThin: 100
    readonly property int weightLight: 300
    readonly property int weightRegular: 400
    readonly property int weightMedium: 500
    readonly property int weightSemiBold: 600
    readonly property int weightBold: 700
    readonly property int weightExtraBold: 800
    readonly property int weightBlack: 900
    
    // ========== DISPLAY (Hero elements like 21:30 clock) ==========
    
    // Display Large
    readonly property int displayLargeSize: 120
    readonly property int displayLargeWeight: weightBold
    readonly property real displayLargeLineHeight: 1.1
    readonly property real displayLargeLetterSpacing: -0.02
    
    // Display Medium
    readonly property int displayMediumSize: 96
    readonly property int displayMediumWeight: weightBold
    readonly property real displayMediumLineHeight: 1.1
    readonly property real displayMediumLetterSpacing: -0.02
    
    // Display Small
    readonly property int displaySmallSize: 72
    readonly property int displaySmallWeight: weightSemiBold
    readonly property real displaySmallLineHeight: 1.1
    readonly property real displaySmallLetterSpacing: -0.01
    
    // Legacy display (for backward compatibility)
    readonly property int displaySize: displayMediumSize
    readonly property int displayWeight: displayMediumWeight
    readonly property real displayLineHeight: displayMediumLineHeight
    readonly property real displayLetterSpacing: displayMediumLetterSpacing
    
    // ========== HEADLINE (Section headers, page titles) ==========
    
    // Headline Large
    readonly property int headlineLargeSize: 56
    readonly property int headlineLargeWeight: weightSemiBold
    readonly property real headlineLargeLineHeight: 1.2
    readonly property real headlineLargeLetterSpacing: -0.01
    
    // Headline Medium
    readonly property int headlineMediumSize: 48
    readonly property int headlineMediumWeight: weightSemiBold
    readonly property real headlineMediumLineHeight: 1.2
    readonly property real headlineMediumLetterSpacing: -0.01
    
    // Headline Small
    readonly property int headlineSmallSize: 40
    readonly property int headlineSmallWeight: weightSemiBold
    readonly property real headlineSmallLineHeight: 1.2
    readonly property real headlineSmallLetterSpacing: 0
    
    // Legacy headline (for backward compatibility)
    readonly property int headlineSize: headlineMediumSize
    readonly property int headlineWeight: headlineMediumWeight
    readonly property real headlineLineHeight: headlineMediumLineHeight
    readonly property real headlineLetterSpacing: headlineMediumLetterSpacing
    
    // ========== TITLE (Card titles, panel headers) ==========
    
    // Title Large
    readonly property int titleLargeSize: 36
    readonly property int titleLargeWeight: weightSemiBold
    readonly property real titleLargeLineHeight: 1.3
    readonly property real titleLargeLetterSpacing: 0
    
    // Title Medium
    readonly property int titleMediumSize: 32
    readonly property int titleMediumWeight: weightSemiBold
    readonly property real titleMediumLineHeight: 1.3
    readonly property real titleMediumLetterSpacing: 0
    
    // Title Small
    readonly property int titleSmallSize: 28
    readonly property int titleSmallWeight: weightMedium
    readonly property real titleSmallLineHeight: 1.3
    readonly property real titleSmallLetterSpacing: 0
    
    // Legacy title (for backward compatibility)
    readonly property int titleSize: titleMediumSize
    readonly property int titleWeight: titleMediumWeight
    readonly property real titleLineHeight: titleMediumLineHeight
    readonly property real titleLetterSpacing: titleMediumLetterSpacing
    
    // ========== SUBTITLE (Secondary titles, descriptions) ==========
    
    // Subtitle Large
    readonly property int subtitleLargeSize: 28
    readonly property int subtitleLargeWeight: weightMedium
    readonly property real subtitleLargeLineHeight: 1.4
    readonly property real subtitleLargeLetterSpacing: 0
    
    // Subtitle Medium
    readonly property int subtitleMediumSize: 24
    readonly property int subtitleMediumWeight: weightMedium
    readonly property real subtitleMediumLineHeight: 1.4
    readonly property real subtitleMediumLetterSpacing: 0
    
    // Subtitle Small
    readonly property int subtitleSmallSize: 20
    readonly property int subtitleSmallWeight: weightRegular
    readonly property real subtitleSmallLineHeight: 1.4
    readonly property real subtitleSmallLetterSpacing: 0
    
    // Legacy subtitle (for backward compatibility)
    readonly property int subtitleSize: subtitleMediumSize
    readonly property int subtitleWeight: subtitleMediumWeight
    readonly property real subtitleLineHeight: subtitleMediumLineHeight
    readonly property real subtitleLetterSpacing: subtitleMediumLetterSpacing
    
    // ========== BODY (Main content, paragraphs) ==========
    
    // Body Large
    readonly property int bodyLargeSize: 18
    readonly property int bodyLargeWeight: weightRegular
    readonly property real bodyLargeLineHeight: 1.5
    readonly property real bodyLargeLetterSpacing: 0
    
    // Body Medium
    readonly property int bodyMediumSize: 16
    readonly property int bodyMediumWeight: weightRegular
    readonly property real bodyMediumLineHeight: 1.5
    readonly property real bodyMediumLetterSpacing: 0
    
    // Body Small
    readonly property int bodySmallSize: 14
    readonly property int bodySmallWeight: weightRegular
    readonly property real bodySmallLineHeight: 1.5
    readonly property real bodySmallLetterSpacing: 0
    
    // Legacy body (for backward compatibility)
    readonly property int bodySize: bodyMediumSize
    readonly property int bodyWeight: bodyMediumWeight
    readonly property real bodyLineHeight: bodyMediumLineHeight
    readonly property real bodyLetterSpacing: bodyMediumLetterSpacing
    
    // ========== LABEL (Form labels, button text, small UI text) ==========
    
    // Label Large
    readonly property int labelLargeSize: 16
    readonly property int labelLargeWeight: weightMedium
    readonly property real labelLargeLineHeight: 1.4
    readonly property real labelLargeLetterSpacing: 0.01
    
    // Label Medium
    readonly property int labelMediumSize: 14
    readonly property int labelMediumWeight: weightMedium
    readonly property real labelMediumLineHeight: 1.4
    readonly property real labelMediumLetterSpacing: 0.01
    
    // Label Small
    readonly property int labelSmallSize: 12
    readonly property int labelSmallWeight: weightMedium
    readonly property real labelSmallLineHeight: 1.4
    readonly property real labelSmallLetterSpacing: 0.02
    
    // Legacy label (for backward compatibility)
    readonly property int labelSize: labelMediumSize
    readonly property int labelWeight: labelMediumWeight
    readonly property real labelLineHeight: labelMediumLineHeight
    readonly property real labelLetterSpacing: labelMediumLetterSpacing
    
    // ========== CAPTION (Helper text, metadata) ==========
    
    readonly property int captionSize: 12
    readonly property int captionWeight: weightRegular
    readonly property real captionLineHeight: 1.4
    readonly property real captionLetterSpacing: 0.02
    
    // ========== MICRO (Smallest text - timestamps, badges) ==========
    
    readonly property int microSize: 10
    readonly property int microWeight: weightMedium
    readonly property real microLineHeight: 1.4
    readonly property real microLetterSpacing: 0.05
    
    // Signal for typography changes
    signal typographyChanged()
}
