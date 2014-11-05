{* xrowform - full view *}

<div class="border-box">
<div class="border-tl"><div class="border-tr"><div class="border-tc"></div></div></div>
<div class="border-ml"><div class="border-mr"><div class="border-mc float-break">

    <div class="content-view-full">
        <div class="class-xrowform">

        <div class="attribute-header">
            <h1>{$node.data_map.name.content|wash()}</h1>
        </div>

        {*if $node.data_map.image.has_content}
            <div class="attribute-image">
                {attribute_view_gui attribute=$node.data_map.image image_class=medium}
            </div>
        {/if*}

        {if and(is_set($node.data_map.description), $node.data_map.description.content.is_empty|not)}
            <div class="attribute-long">
                {attribute_view_gui attribute=$node.data_map.description}
            </div>
        {/if}

        {if and(is_set($node.data_map.intro), $node.data_map.intro.content.is_empty|not)}
            <div class="attribute-long">
                {attribute_view_gui attribute=$node.data_map.intro}
            </div>
        {/if}

        {if $node.data_map.form.has_content}
            {attribute_view_gui attribute=$node.data_map.form}
        {/if}

         {if and( is_set( $node.data_map.body_bottom ), $node.data_map.body_bottom.content.is_empty|not )}
            <div class="attribute-long">
                {attribute_view_gui attribute=$node.data_map.body_bottom}
            </div>
        {/if}

        </div>
    </div>
</div></div></div>
<div class="border-bl"><div class="border-br"><div class="border-bc"></div></div></div>
</div>