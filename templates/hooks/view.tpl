{if count($collections) > 0}
{pageaddvar name='stylesheet' value='modules/MUFiles/style/style.css'}
<div class='mucollectionshook'>
<ul>
{foreach item='collection' from=$collections }
    {foreach item='singlecollection' from=$collection}
        <li class='hookcollection'>
        {* <a href='{modurl modname='MUFiles' type='user' func='view' tag=$tag.slug|safetext}'><span class='taghole'>&bull;</span>{$collection.name|safetext}</a> *}
            <h2>{$singlecollection.name}</h2>
            {if $singlecollection.alilasfile ne NULL}
                {foreach item='file' from=$singlecollection.alilasfile}
                    <a href="{modurl modname='MUFiles' type='user' func='giveFile' id=$file.id}">{$file.title}</a>
                {/foreach}
                    
            {/if}

</li>
{/foreach}
{/foreach}
</ul>
</div>
{/if}
{if count($files) > 0 && is_array($files)}
<div class='mufileshook'>
<h2>{gt text='Files'}</h2>
<ul>
{foreach item='file' from=$files }
{foreach item='singlefile' from=$file }
        <li class='hookfile'>
            <a href="{modurl modname='MUFiles' type='user' func='giveFile' id=$singlefile.id}">{$singlefile.title}</a>         
        </li>
{/foreach}
{/foreach}
</ul>
</div>
{/if}