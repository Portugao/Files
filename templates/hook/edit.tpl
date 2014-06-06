<fieldset>
{if $module eq 'News'}
    <legend>{gt text="Create MUImage Album"}</legend>
    <div class="mufiles-hook z-formrow">
        <label for="mufiles-albumyes">{gt text='Create Album and add the uploaded pictures?'}</label>
        <input type="checkbox" id="mufiles-albumyes" name="mufiles-albumyes" />
    </div>
        <div class="mufiles-hook z-formrow">
        <label for="mufiles-album">{gt text='Add pictures to main album:'}</label>
        <select id="mufiles-collection" name="mufiles-collection">
            <option value="">{gt text='Select a collection'}</option>
            {foreach item='collection' from=$collections}
                <option value={$collection.id}>{$collection.name}</option>
            {/foreach}
        </select>
    </div>  
        <div class="mufiles-hook z-formrow">
        <label for="mufiles-subalbum">{gt text='Add pictures to sub album:'}</label>
        <select id="mufiles-subalbum" name="mufiles-subalbum">
            <option value="">{gt text='Select a sub album'}</option>
            {foreach item='subalbum' from=$subalbums}
                <option value={$subalbum.id}>{$subalbum.title}</option>
            {/foreach}
        </select>
    </div>
{else}
    <legend>{gt text="Select collection or file"}</legend>
    <div class="">
    <div class="mufiles-hook z-formrow">
        <label for="mufiles-collection">{gt text='Select a collection!'}</label>
        <select id="mufiles-collection" name="mufiles-collection">
            <option value="">{gt text='Select a collection'}</option>
            {foreach item='collection' from=$collections}
                <option value={$collection.id}>{$collection.name}</option>
            {/foreach}
        </select>
    </div>
    <div class="mufiles-hook z-formrow">
        <label for="mufiles-file">{gt text='Select a file!'}</label>
        <select id="mufiles-file" name="mufiles-file">
            <option value="">{gt text='Select a file'}</option>
            {foreach item='file' from=$files}
                <option value={$file.id}>{$file.title}</option>
            {/foreach}
        </select>
    </div>
    </div>
{/if}
</fieldset>
