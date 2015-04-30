{* purpose of this template: module configuration *}
{include file='admin/header.tpl'}
<div class="mufiles-config">
    {gt text='Import' assign='templateTitle'}
    {pagesetvar name='title' value=$templateTitle}
    <div class="z-admin-content-pagetitle">
        {icon type='config' size='small' __alt='Import'}
        <h3>{$templateTitle}</h3>
    </div>

    {form cssClass='z-form'}
        {* add validation summary and a <div> element for styling the form *}
        {mufilesFormFrame}
            {formsetinitialfocus inputId='allowedExtensions'}
            {formtabbedpanelset}
                {gt text='Import of categories' assign='tabTitle'}
                {formtabbedpanel title=$tabTitle}
                    <fieldset>
                        <legend>{$tabTitle}</legend>
                    
                        <p class="z-confirmationmsg">{gt text='Here you can import the categories of download module to collections of MUFiles.'}</p>
                    
                    </fieldset>
                <div class="z-buttons z-formbuttons">
                	{formbutton commandName='importCats' __text='Import categories' class='z-bt-save'}
                	{formbutton commandName='cancel' __text='Cancel' class='z-bt-cancel'}
            	</div>
                {/formtabbedpanel}
                {gt text='Import of files' assign='tabTitle'}
                {formtabbedpanel title=$tabTitle}
                    <fieldset>
                        <legend>{$tabTitle}</legend>
                    
                        <p class="z-confirmationmsg">{gt text='Here you can import files of module Downloads to files of MUFiles.'|nl2br}</p>
                    
                    </fieldset>
                <div class="z-buttons z-formbuttons">
                	{formbutton commandName='importFiles' __text='Import files' class='z-bt-save'}
                	{formbutton commandName='cancel' __text='Cancel' class='z-bt-cancel'}
            	</div>
                {/formtabbedpanel}
            {/formtabbedpanelset}

 
        {/mufilesFormFrame}
    {/form}
</div>
{include file='admin/footer.tpl'}
<script type="text/javascript">
/* <![CDATA[ */
    document.observe('dom:loaded', function() {
        Zikula.UI.Tooltips($$('.mufiles-form-tooltips'));
    });
/* ]]> */
</script>
