import QtQuick
import "../tokens" as Tokens
import "../theme" as Theme

/**
 * Real OS Text Primitive
 * 
 * Text primitive that provides consistent typography.
 * Consumes typography tokens and semantic color roles.
 */
Text {
    id: root
    
    // Text style
    enum TextStyle {
        Display,
        Headline,
        Title,
        Subtitle,
        Body,
        Label,
        Caption,
        Micro
    }
    
    property int textStyle: Text.Body
    
    // Design Tokens
    Tokens.Colors { id: colors }
    Tokens.Typography { id: typography }
    Tokens.Motion { id: motion }
    Theme.Theme { id: theme }
    
    // Styling based on text style
    font.family: typography.fontFamily
    font.pixelSize: {
        switch(textStyle) {
            case Text.Display: return typography.displaySize
            case Text.Headline: return typography.headlineSize
            case Text.Title: return typography.titleSize
            case Text.Subtitle: return typography.subtitleSize
            case Text.Body: return typography.bodySize
            case Text.Label: return typography.labelSize
            case Text.Caption: return typography.captionSize
            case Text.Micro: return typography.microSize
            default: return typography.bodySize
        }
    }
    
    font.weight: {
        switch(textStyle) {
            case Text.Display: return typography.displayWeight
            case Text.Headline: return typography.headlineWeight
            case Text.Title: return typography.titleWeight
            case Text.Subtitle: return typography.subtitleWeight
            case Text.Body: return typography.bodyWeight
            case Text.Label: return typography.labelWeight
            case Text.Caption: return typography.captionWeight
            case Text.Micro: return typography.microWeight
            default: return typography.bodyWeight
        }
    }
    
    lineHeight: {
        switch(textStyle) {
            case Text.Display: return typography.displayLineHeight
            case Text.Headline: return typography.headlineLineHeight
            case Text.Title: return typography.titleLineHeight
            case Text.Subtitle: return typography.subtitleLineHeight
            case Text.Body: return typography.bodyLineHeight
            case Text.Label: return typography.labelLineHeight
            case Text.Caption: return typography.captionLineHeight
            case Text.Micro: return typography.microLineHeight
            default: return typography.bodyLineHeight
        }
    }
    
    letterSpacing: {
        switch(textStyle) {
            case Text.Display: return typography.displayLetterSpacing
            case Text.Headline: return typography.headlineLetterSpacing
            case Text.Title: return typography.titleLetterSpacing
            case Text.Subtitle: return typography.subtitleLetterSpacing
            case Text.Body: return typography.bodyLetterSpacing
            case Text.Label: return typography.labelLetterSpacing
            case Text.Caption: return typography.captionLetterSpacing
            case Text.Micro: return typography.microLetterSpacing
            default: return typography.bodyLetterSpacing
        }
    }
    
    color: colors.colorContentPrimary
    
    // Opacity state
    property bool disabled: false
    
    opacity: disabled ? 0.5 : 1.0
    
    Behavior on opacity {
        NumberAnimation {
            duration: motion.fast
            easing: motion.easingOutCubic
        }
    }
}
