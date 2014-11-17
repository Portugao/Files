{if count($collections) > 0 && is_array($collections)}
{pageaddvar name='stylesheet' value='modules/MUFiles/style/style.css'}
<div class='mucollectionshook'>
<ul>
{foreach item='collection' from=$collections }
    {foreach item='singlecollection' from=$collection}
    {checkpermissionblock component='MUFiles:Collection:' instance='::' level='ACCESS_COMMENT'}
    {checkpermissionblock component='MUFiles:Collection:' instance='`$singlecollection.id`::' level='ACCESS_COMMENT'}
        <li class='hookcollection'>
        {* <a href='{modurl modname='MUFiles' type='user' func='view' tag=$tag.slug|safetext}'><span class='taghole'>&bull;</span>{$collection.name|safetext}</a> *}
            <h2><a title="{gt text='See the complete collection'}" href="{modurl modname='MUFiles' type='user' func='display' ot='collection' id=$singlecollection.id}">{$singlecollection.name}</a></h2>
            {if $singlecollection.alilasfile ne NULL}
                {foreach item='file' from=$singlecollection.alilasfile}
                    <a href="{modurl modname='MUFiles' type='user' func='giveFile' id=$file.id}">{$file.title}</a>
                {/foreach}                
            {/if}
        </li>
    {/checkpermissionblock}
    {/checkpermissionblock}
    {/foreach}
{/foreach}
</ul>
</div>
{/if}
{if $files ne ''}
<div class='mufileshook'>
<h2>{gt text='Files'}</h2>
<ul>
{foreach item='file' from=$files }
    {foreach item='singlefile' from=$file}
    {checkpermissionblock component='MUFiles:File:' instance='::' level='ACCESS_COMMENT'}
        <li class='hookfile'>
            <a href="{modurl modname='MUFiles' type='user' func='giveFile' id=$singlefile.id}">{$singlefile.title}</a>         
        </li>
    {/checkpermissionblock}
    {/foreach}
{/foreach}
</ul>
</div>
{/if}