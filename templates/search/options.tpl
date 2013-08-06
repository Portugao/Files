{* Purpose of this template: Display search options *}
<input type="hidden" id="active_mufiles" name="active[MUFiles]" value="1" checked="checked" />
<div>
    <input type="checkbox" id="active_mufiles_collections" name="search_mufiles_types['collection']" value="1"{if $active_collection} checked="checked"{/if} />
    <label for="active_mufiles_collections">{gt text='Collections' domain='module_mufiles'}</label>
</div>
<div>
    <input type="checkbox" id="active_mufiles_files" name="search_mufiles_types['file']" value="1"{if $active_file} checked="checked"{/if} />
    <label for="active_mufiles_files">{gt text='Files' domain='module_mufiles'}</label>
</div>
