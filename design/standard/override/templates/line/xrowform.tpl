{run-once}
{ezcss_require( array( 'xrowformgenerator.css' ) )}
{/run-once}
{* xrowform - line view *}

<div class="content-view-line">
    <div class="class-article float-break">

    <h2><a href={$node.url_alias|ezurl}>{$node.data_map.name.content|wash}</a></h2>

    {if $node.data_map.image.has_content}
        <div class="attribute-image">
            {attribute_view_gui image_class=articlethumbnail href=$node.url_alias|ezurl attribute=$node.data_map.image}
        </div>
    {/if}

    {if $node.data_map.intro.content.is_empty|not}
    <div class="attribute-short">
        {attribute_view_gui attribute=$node.data_map.intro}
    </div>
    {/if}

    </div>
</div>