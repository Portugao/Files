SCRIBITE INTEGRATION
--------------------

It is easy to include MUFiles in your Scribite editors.
While MUFiles contains already the a popup for selecting collections and other items,
the actual Scribite enhancements must be done manually for Scribite <= 4.3.
From Scribite 5.0 onwards the integration is automatic. The necessary javascript is loaded via event system and the
plugins are already in the Scribite package.

Just follow these few steps to complete the integration for Scribite <= 4.3:
  1. Open modules/Scribite/lib/Scribite/Api/User.php in your favourite text editor.
  2. Search for
        if (ModUtil::available('SimpleMedia')) {
            PageUtil::addVar('javascript', 'modules/SimpleMedia/javascript/findItem.js');
        }
  3. Below this add
        if (ModUtil::available('MUFiles')) {
            PageUtil::addVar('javascript', 'modules/MUFiles/javascript/MUFiles_finder.js');
        }
  4. Copy or move all files from modules/MUFiles/docs/scribite/includes/ into modules/Scribite/includes/.

Just follow these few steps to complete the integration for Scribite >= 5.0:
 1. Check if the plugins for MUFiles are in Scribite/plugins/EDITOR/vendor/plugins. If not then copy from
    modules/MUFiles/docs/scribite/includes into modules/Scribite/plugins.
