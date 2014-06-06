{* Purpose of this template: Display search options *}
<input type="hidden" id="mUFilesActive" name="active[MUFiles]" value="1" checked="checked" />
<div>
    <input type="checkbox" id="active_mUFilesCollections" name="mUFilesSearchTypes[]" value="collection"{if $active_collection} checked="checked"{/if} />
    <label for="active_mUFilesCollections">{gt text='Collections' domain='module_mufiles'}</label>
</div>
<div>
    <input type="checkbox" id="active_mUFilesFiles" name="mUFilesSearchTypes[]" value="file"{if $active_file} checked="checked"{/if} />
    <label for="active_mUFilesFiles">{gt text='Files' domain='module_mufiles'}</label>
</div>
<div>
    <input type="checkbox" id="active_mUFilesHookobjects" name="mUFilesSearchTypes[]" value="hookobject"{if $active_hookobject} checked="checked"{/if} />
    <label for="active_mUFilesHookobjects">{gt text='Hookobjects' domain='module_mufiles'}</label>
</div>
