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
                {gt text='Import of downloads module' assign='tabTitle'}
                {formtabbedpanel title=$tabTitle}
                    <fieldset>
                        <legend>{$tabTitle}</legend>
                    
                        <p class="z-confirmationmsg">{gt text='Here you can import the categories and downloads of downloads module to collections and files of MUFiles.'}</p>
                    
                    </fieldset>
                <div class="z-buttons z-formbuttons">
                	{formbutton commandName='importCats' __text='Import datas of module' class='z-bt-save'}
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
