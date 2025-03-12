//======================================================================================
// OneMaker MV's Window Size Constants
//======================================================================================
/* Use the list of constants for window sizing.
 * Uncomment/Comment all lines as necessary.
 * 
 * You can also just modify the 1080p ones and use custom values.
*/
//======================================================================================
pragma Singleton
import QtQuick 2.3

QtObject {
    // 1080p+ Resolution Constants
    readonly property int defaultWidthIncrease: 200
    readonly property int defaultHeightIncrease: 200
    readonly property int alternativeWidthIncrease: 100
    readonly property int alternativeHeightIncrease: 100
    readonly property int groupAnimationTimingsListBoxWidth: 298
    readonly property int groupNoteDatabaseWidth: 940
    readonly property int groupNoteDatabaseX: -420
    readonly property int groupEffectsListBoxWidth: 116
    readonly property int groupTraitsListBoxWidth: 116
    readonly property int layoutEventEditorNoteWidth: 460

    // 720p Resolution Constants
    //readonly property int defaultWidthIncrease: 180
    //readonly property int defaultHeightIncrease: 100
    //readonly property int alternativeWidthIncrease: 80
    //readonly property int alternativeHeightIncrease: 80
    //readonly property int groupAnimationTimingsListBoxWidth: 282
    //readonly property int groupNoteDatabaseWidth: 920
    //readonly property int groupNoteDatabaseX: -420
    //readonly property int groupEffectsListBoxWidth: 116
    //readonly property int groupTraitsListBoxWidth: 116
    //readonly property int layoutEventEditorNoteWidth: 440

    // Default  Constants
    //readonly property int defaultWidthIncrease: 0
    //readonly property int defaultHeightIncrease: 100 // Default size is actually 0, but with the addition of Self Variable and Script Event Page Conditions an increase of width by 100 is required so no elements are clipping.
    //readonly property int alternativeWidthIncrease: 0
    //readonly property int alternativeHeightIncrease: 0
    //readonly property int groupAnimationTimingsListBoxWidth: 282
    //readonly property int groupNoteDatabaseWidth: 320
    //readonly property int groupNoteDatabaseX: 0
    //readonly property int groupEffectsListBoxWidth: 0
    //readonly property int groupTraitsListBoxWidth: 0
    //readonly property int layoutEventEditorNoteWidth: 164
}