<fieldset>
    <legend>{gt text="MUFiles"}</legend>
    <div class="">
    <div class="mufiles-hook z-formrow">
        <label for="mufiles-collection">{gt text='Select a collection!'}</label>
        <select id="mufiles-collection" name="mufilescollection[]" multiple=multiple>
            <option value=""></option>
            {foreach item='collection' from=$collections}
                <option value={$collection.id}>{$collection.name}</option>
            {/foreach}
        </select>
    </div>
    <div class="mufiles-hook z-formrow">
        <label for="mufiles-file">{gt text='Select a file!'}</label>
        <select id="mufiles-file" name="mufilesfile[]" multiple=multiple>
            <option value=""></option>
            {foreach item='file' from=$files}
                <option value={$file.id}>{$file.title}</option>
            {/foreach}
        </select>
    </div>
    </div>
</fieldset>
