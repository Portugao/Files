{pageaddvar name='stylesheet' value='modules/MUFiles/style/style.css'}
{if $hookcollections ne ''}
<div class='mucollectionshook'>
<ul>

    {foreach item='singlecollection' from=$hookcollections}
    {checkpermissionblock component='MUFiles:Collection:' instance='::' level='ACCESS_COMMENT'}
    {checkpermissionblock component='MUFiles:Collection:' instance='`$singlecollection.id`::' level='ACCESS_COMMENT'}
        <li class='hookcollection'>
            <h2><a title="{gt text='See the complete collection'}" href="{modurl modname='MUFiles' type='user' func='display' id=$singlecollection.id}">{$singlecollection.name}</a></h2>
            {if $singlecollection.alilasfile ne NULL}
                {foreach item='file' from=$singlecollection.alilasfile}
                    <a href="{modurl modname='MUFiles' type='user' func='giveFile' ot='file' id=$file.id}">{$file.title}</a>
                {/foreach}                
            {/if}
        </li>
    {/checkpermissionblock}
    {/checkpermissionblock}
    {/foreach}

</ul>
</div>
{/if}
{if $hookfiles ne ''}
<div class='mufileshook'>
<h2>{gt text='Files'}</h2>
<ul>
    {foreach item='singlefile' from=$hookfiles}
    {checkpermissionblock component='MUFiles:File:' instance='::' level='ACCESS_COMMENT'}
        <li class='hookfile'>
            <a href="{modurl modname='MUFiles' type='user' func='giveFile' ot='file' id=$singlefile.id}">{$singlefile.title}</a>         
        </li>
    {/checkpermissionblock}
    {/foreach}
</ul>
</div>
{/if}