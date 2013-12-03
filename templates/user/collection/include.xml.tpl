{* purpose of this template: collections xml inclusion template in user area *}
<collection id="{$item.id}" createdon="{$item.createdDate|dateformat}" updatedon="{$item.updatedDate|dateformat}">
    <id>{$item.id}</id>
    <name><![CDATA[{$item.name}]]></name>
    <description><![CDATA[{$item.description}]]></description>
    <parentid>{$item.parentid}</parentid>
    <workflowState>{$item.workflowState|mufilesObjectState:false|lower}</workflowState>
    <parent>{if isset($item.Parent) && $item.Parent ne null}{$item.Parent->getTitleFromDisplayPattern()|default:''}{/if}</parent>
    <alilasfile>
    {if isset($item.Alilasfile) && $item.Alilasfile ne null}
        {foreach name='relationLoop' item='relatedItem' from=$item.Alilasfile}
        <file>{$relatedItem->getTitleFromDisplayPattern()|default:''}</file>
        {/foreach}
    {/if}
    </alilasfile>
    <children>
    {if isset($item.Children) && $item.Children ne null}
        {foreach name='relationLoop' item='relatedItem' from=$item.Children}
        <collection>{$relatedItem->getTitleFromDisplayPattern()|default:''}</collection>
        {/foreach}
    {/if}
    </children>
</collection>
