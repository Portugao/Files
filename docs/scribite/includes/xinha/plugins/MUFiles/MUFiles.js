// MUFiles plugin for Xinha
// developed by Michael Ueberschaer
//
// requires MUFiles module (http://webdesign-in-bremen.com)
//
// Distributed under the same terms as xinha itself.
// This notice MUST stay intact for use (see license.txt).

'use strict';

function MUFiles(editor) {
    var cfg, self;

    this.editor = editor;
    cfg = editor.config;
    self = this;

    cfg.registerButton({
        id       : 'MUFiles',
        tooltip  : 'Insert MUFiles object',
     // image    : _editor_url + 'plugins/MUFiles/img/ed_MUFiles.gif',
        image    : '/images/icons/extrasmall/favorites.png',
        textMode : false,
        action   : function (editor) {
            var url = Zikula.Config.baseURL + 'index.php'/*Zikula.Config.entrypoint*/ + '?module=MUFiles&type=external&func=finder&editor=xinha';
            MUFilesFinderXinha(editor, url);
        }
    });
    cfg.addToolbarElement('MUFiles', 'insertimage', 1);
}

MUFiles._pluginInfo = {
    name          : 'MUFiles for xinha',
    version       : '1.0.0',
    developer     : 'Michael Ueberschaer',
    developer_url : 'http://webdesign-in-bremen.com',
    sponsor       : 'ModuleStudio 0.6.1',
    sponsor_url   : 'http://modulestudio.de',
    license       : 'htmlArea'
};
