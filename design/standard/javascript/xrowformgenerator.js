function xrow_option_button_up()
{
    var li = YAHOO.util.Dom.getAncestorByTagName( this, 'li' );
    return xrow_move( { direction: 'up', ele: li } );
}

function xrow_option_button_down()
{
    var li = YAHOO.util.Dom.getAncestorByTagName( this, 'li' );
    return xrow_move(  { direction: 'down', ele: li } );
}

function xrow_element_button_up()
{
    var li = YAHOO.util.Dom.getAncestorByTagName( this, 'li' );
    return xrow_move( {direction: 'up', ele: li } );
}

function xrow_element_button_down()
{
    var li = YAHOO.util.Dom.getAncestorByTagName( this, 'li' );
    return xrow_move( {direction: 'down', ele: li });
}

function xrow_option_trash_button()
{
    var li = YAHOO.util.Dom.getAncestorByTagName( this, 'li' );
    var ol = YAHOO.util.Dom.getAncestorByTagName( this, 'ol' );

    if ( li && ol )
    {
        ol.removeChild( li );
    }
}

function xrow_form_element_trash_button()
{
    var li = YAHOO.util.Dom.getAncestorByTagName( this, 'li' );
    var ol = YAHOO.util.Dom.getAncestorByTagName( this, 'ol' );

    if ( li && ol )
    {
        ol.removeChild( li );
    }
}

function xrow_add_option_button( button, el )
{
    xrow_add_option( 'xrow-options-tpl-' + el.id, 'XrowOptionList_{$id}_' + el.index, {} );
    return false;
}

function insertAfter( newElement, targetElement )
{
    var parent = targetElement.parentNode;
    if ( parent.lastChild == targetElement )
    {
        parent.appendChild(newElement);
    }
    else
    {
        parent.insertBefore(newElement, targetElement.nextSibling);
    }
}
function in_array(item,arr)
{
    for( p=0; p<arr.length; p++)
        if (item == arr[p])
            return true;
    return false;
}

/* create a random id */
var xrow_unique_id_array = [];

function xrow_generate_id( maxchars )
{
    var i = 0;
    var result = '';
    do
    {
        result = xrow_random_id( maxchars, false, '-' );
        i++;
    } while ( i < 100 && in_array( result, xrow_unique_id_array ) )
    xrow_unique_id_array[xrow_unique_id_array.length] = result;
    return result;
}

function xrow_random_id( maxchars, add_delimiter, delimiter )
{
    var result, i, j;
    result = '';
    for ( j=0; j < maxchars; j++)
    {
        if ( add_delimiter && j > 0 && j % 4 == 0 )
        {
            result = result + delimiter;
        }
        i = Math.floor( Math.random() * 16 ).toString( 16 ).toLowerCase();
        result = result + i;
    }
    return result;
}

// moves an element up and down at one level of the node tree
function xrow_move( data )
{
    var tag = 'li'
    if ( data.tag )
    {
        tag = data.tag;
    }

    if ( data.ele )
    {
        var list = data.ele.parentNode;
        var li_ele = data.ele;

        var all_items = list.getElementsByTagName( tag );
        var items = [];
        for ( var i = 0; i < all_items.length; i++ )
        {
            // only take elements of the first level
            if ( all_items[i].parentNode == list )
            {
                items[items.length] = all_items[i];
            }
        }
        var list_length = items.length;

        var x = -1;
        if ( data.direction == 'down' )
        {
            x = 1;
        }

        if ( list_length > 1 )
        {
            for ( var i = 0; i < list_length; i++ )
            {
                if ( li_ele == items[i] )
                {
                    // found the element
                    if ( ( i + x ) > -1 && items[i+x] )
                    {
                        if ( x == 1 )
                        {
                            insertAfter( li_ele, items[i+x] );
                        }
                        else
                        {
                            list.insertBefore( li_ele, items[i+x] );
                        }
                        return true;
                    }
                    else
                    {
                        if ( x == 1 )
                        {
                            list.insertBefore( li_ele, items[0] );
                        }
                        else
                        {
                            list.removeChild( li_ele );
                            list.appendChild( li_ele );
                        }
                        return true;
                    }
                }
            }
        }
    }
}

function findAttribute( selectBoxID )
{
    var selectBox = document.getElementById( selectBoxID );
    if ( selectBox )
    {
        for ( var i = 0; i < selectBox.options.length; i++ )
        {
            if ( selectBox.options[i].selected == true )
                return selectBox.options[i].value;
        }
    }
}

function findAttributeName( selectBoxID )
{
    var selectBox = document.getElementById( selectBoxID );
    if ( selectBox )
    {
        for ( var i = 0; i < selectBox.options.length; i++ )
        {
            if ( selectBox.options[i].selected == true )
                return selectBox.options[i].text;
        }
    }
}
/********************************************************/
/* IE has problems with innerHTML
   This script solves it...
   No script is allowed in the html code
   taken from http://stackoverflow.com/questions/1231770/innerhtml-removes-attribute-quotes-in-internet-explorer */
function ieInnerHTML(obj) {
 var zz = obj.innerHTML,
     z =
   zz.match(/<\/?\w+((\s+\w+(\s*=\s*(?:".*?"|'.*?'|[^\'\">\s]+))?)+\s*|\s*)\/?>/g);
  if (z){
    for (var i=0;i<z.length;i++){
      var y, zSaved = z[i];
      z[i] = z[i].replace(/(<?\w+)|(<\/?\w+)\s/,
                          function(a){return a.toLowerCase();});
      y = z[i].match(/\=\w+[?\s+|?>]/g);
       if (y){
        for (var j=0;j<y.length;j++){
          z[i] = z[i].replace(y[j],y[j]
                     .replace(/\=(\w+)([?\s+|?>])/g,'="$1"$2'));
        }
       }
       zz = zz.replace(zSaved,z[i]);
     }
   }
  return zz;
 }
/********************************************************/

function xrow_add_form_default( attr_value_id, ol_con_id, attribute_id, index, opt, attr_type )
{
    var li_tpl = document.getElementById( attr_value_id );
    var ol_con = document.getElementById( ol_con_id );

    if ( li_tpl && ol_con )
    {
        var new_li = document.createElement( "li" );
        new_li.className = li_tpl.className;

        var pattern_index = /yyyxrowindexyyy/g;
        var pattern_name = /yyyxrownameyyy/g;
        var pattern_desc = /yyyxrowdescyyy/g;
        var pattern_req = /yyyxrowreqyyy/g;
        var pattern_val = /yyyxrowvalyyy/g;
        var pattern_xrow = /x1Xrow/g;
        var pattern_def = /yyyxrowdefyyy/g;

        var temphtml = ieInnerHTML( li_tpl );
        temphtml = temphtml.replace( pattern_index, index );

        temphtml = temphtml.replace( pattern_xrow, "Xrow" );

        var nname = '';
        if ( opt.name != undefined )
            nname = opt.name;
        temphtml = temphtml.replace( pattern_name, nname );

        var def = '';
        if ( opt.def != undefined )
        {
            if ( attr_type == 'checkbox' )
            {
                if ( opt.def )
                {
                    def = '1" checked="checked';
                }
            }
            else
            {
                def = opt.def;
            }
        }
        temphtml = temphtml.replace( pattern_def, def );

        var desc = '';
        if ( opt.desc != undefined )
            desc = opt.desc;
        temphtml = temphtml.replace( pattern_desc, desc );

        new_li.innerHTML = temphtml;

        // set required checkbox
        var req_array = YAHOO.util.Dom.getElementsByClassName( 'xrow-form-element-required', 'input', new_li );
        if ( req_array[0] != undefined && opt && opt.req != undefined && opt.req)
        {
            req_array[0].checked = true;
        }

        // set validation checkbox
        var val_array = YAHOO.util.Dom.getElementsByClassName( 'xrow-form-element-validation', 'input', new_li );
        if ( val_array[0] != undefined && opt && opt.val != undefined && opt.val)
        {
            val_array[0].checked = true;
        }

        // add move event
        YAHOO.util.Event.addListener( YAHOO.util.Dom.getElementsByClassName( 'xrow-element-button-up', 'img', new_li ), "click", xrow_element_button_up );
        YAHOO.util.Event.addListener( YAHOO.util.Dom.getElementsByClassName( 'xrow-element-button-down', 'img', new_li ), "click", xrow_element_button_down );

        // add trash event
        YAHOO.util.Event.addListener( YAHOO.util.Dom.getElementsByClassName( 'xrow-form-element-trash-button', 'img', new_li ), "click", xrow_form_element_trash_button );

        if ( ol_con.hasChildNodes() )
            insertAfter( new_li, ol_con.lastChild );
        else
            ol_con.appendChild( new_li );
        index++;
    }
    return index;
}

function xrow_add_option( opt_tpl_id, ol_id, opt, index )
{
    var li_tpl = document.getElementById( opt_tpl_id );
    var ol_con = document.getElementById( ol_id );

    var index_z = xrow_random_id( 7, false, '-' );
    if ( li_tpl && ol_con )
    {
        // calc current index
        if ( index == undefined )
        {
            var index_pat = /_([0-9]+)$/;
            var index_y_array = ol_id.match( index_pat );
            var index_y = index_y_array[1];
        }
        else
        {
            var index_y = index;
        }

        var new_li = document.createElement( "li" );
        new_li.className = li_tpl.className;

        var pattern_index_y = /yyyxrowindexyyy/gi;
        var pattern_index_z = /zzzxrowindexzzz/gi;
        var pattern_name = /zzzxrowoptionnamezzz/gi;
        var pattern_image = /zzzxrowoptionimagezzz/gi;
        var pattern_def = /zzzxrowoptiondefzzz/gi;

        var pattern_xrow = /x1Xrow/g;

        var temphtml = ieInnerHTML( li_tpl );
        temphtml = temphtml.replace( pattern_index_y, index_y );
        temphtml = temphtml.replace( pattern_index_z, index_z );
        temphtml = temphtml.replace( pattern_xrow, 'Xrow' );

        var name = '';
        if ( opt.name != undefined )
            name = opt.name;
        temphtml = temphtml.replace( pattern_name, name );

        var myimage = 0;
        if ( opt.image != undefined )
        {
            myimage = opt.image;

        }
        temphtml = temphtml.replace( pattern_image, myimage );

        new_li.innerHTML = temphtml;

        // add move event
        YAHOO.util.Event.addListener( YAHOO.util.Dom.getElementsByClassName( 'xrow-option-button-up', 'img', new_li ), "click", xrow_option_button_up );
        YAHOO.util.Event.addListener( YAHOO.util.Dom.getElementsByClassName( 'xrow-option-button-down', 'img', new_li ), "click", xrow_option_button_down );

        // add trash event
        YAHOO.util.Event.addListener( YAHOO.util.Dom.getElementsByClassName( 'xrow-option-trash-button', 'img', new_li ), "click", xrow_option_trash_button );

        // check default button
        var def_array = YAHOO.util.Dom.getElementsByClassName( 'xrow-option-default-button', 'input', new_li );
        if ( def_array[0] != undefined && opt && opt.def != undefined && opt.def)
        {
            def_array[0].checked = true;
        }

        if ( ol_con.childNodes.length > 0 )
        {
            insertAfter( new_li, ol_con.lastChild );
        }
        else
        {
            ol_con.appendChild( new_li );
        }

        if ( opt.image_src && opt.attribute_id )
        {
            var myimg = document.getElementById ( "XrowOptionImage" + opt.attribute_id + "_" + index_y + "_" + index_z );
            if ( myimg )
            {
                myimg.src = opt.image_src;
                if ( opt.width )
                {
                     myimg.width = opt.width;
                }
                if ( opt.height )
                {
                    myimg.height = opt.height;
                }
            }
        }
    }
}

function xrow_add_saved_options( opt_tpl_id, ol_id, opt, index )
{
    if ( opt != undefined && opt && opt.option_array )
    {
        for( property in opt.option_array )
        {
        	xrow_add_option( ol_id, opt_tpl_id, opt.option_array.property, index );
        }
    }
}

function xrow_add_form_options( attr_value_id, ol_con_id, attribute_id, index, opt, ol_id, opt_tpl_id )
{
    var li_tpl = document.getElementById( attr_value_id );
    var ol_con = document.getElementById( ol_con_id );

    if ( li_tpl && ol_con )
    {
        var new_li = document.createElement( "li" );
        new_li.className = li_tpl.className;

        var pattern_index = /yyyxrowindexyyy/gi;
        var pattern_name = /yyyxrownameyyy/gi;
        var pattern_desc = /yyyxrowdescyyy/gi;
        var pattern_req = /yyyxrowreqyyy/gi;
        var pattern_opt = /yyyxrowoptioncontentyyyy/gi;
        var pattern_xrow = /x1Xrow/g;

        var temphtml = ieInnerHTML( li_tpl );
        temphtml = temphtml.replace( pattern_index, index );
        temphtml = temphtml.replace( pattern_xrow, 'Xrow' );

        var name = '';
        if ( opt.name != undefined )
            name = opt.name;
        temphtml = temphtml.replace( pattern_name, name );

        var desc = '';
        if ( opt.desc != undefined )
            desc = opt.desc;
        temphtml = temphtml.replace( pattern_desc, desc );

        new_li.innerHTML = temphtml;

        // set required checkbox
        var req_array = YAHOO.util.Dom.getElementsByClassName( 'xrow-form-element-required', 'input', new_li );
        if ( req_array[0] != undefined && opt && opt.req != undefined && opt.req)
        {
            req_array[0].checked = true;
        }

        // set validation checkbox
        var val_array = YAHOO.util.Dom.getElementsByClassName( 'xrow-form-element-validation', 'input', new_li );
        if ( val_array[0] != undefined && opt && opt.val != undefined && opt.val)
        {
            val_array[0].checked = true;
        }

        // set option type
        var sel_array = YAHOO.util.Dom.getElementsByClassName( 'xrow-form-element-option-type', 'select', new_li );
        if ( sel_array[0] != undefined && opt.option_type != undefined && opt.option_type )
        {
            for ( var i = 0; i < sel_array[0].options.length; i++ )
            {
                if ( sel_array[0].options[i].value == opt.option_type )
                {
                    sel_array[0].options[i].selected = true;
                }
            }
        }

        // add move event
        YAHOO.util.Event.addListener( YAHOO.util.Dom.getElementsByClassName( 'xrow-element-button-up', 'img', new_li ), "click", xrow_element_button_up );
        YAHOO.util.Event.addListener( YAHOO.util.Dom.getElementsByClassName( 'xrow-element-button-down', 'img', new_li ), "click", xrow_element_button_down );

        // add trash event
        YAHOO.util.Event.addListener( YAHOO.util.Dom.getElementsByClassName( 'xrow-form-element-trash-button', 'img', new_li ), "click", xrow_form_element_trash_button );

        // add option event
        YAHOO.util.Event.addListener( YAHOO.util.Dom.getElementsByClassName( 'xrow-form-add-option-button', 'button', new_li ), "click", xrow_add_option_button, { id: attribute_id, index: index } );

        if ( ol_con.hasChildNodes() )
            insertAfter( new_li, ol_con.lastChild );
        else
            ol_con.appendChild( new_li );

        if ( opt.option_array != undefined && opt.option_array )
        {
            for( property in opt.option_array )
            {
            	xrow_add_option( ol_id, opt_tpl_id + index, opt.option_array[property], index );
            }

            //xrow_add_saved_options( opt_tpl_id + index, ol_id, opt, index );
        }

        index++;
    }
    return index;
}

function xrow_add_form_element( select_id, ol_con_id, index, attribute_id, opt )
{
    attr_value = findAttribute( select_id );
    attr_value_id = "xrow-form-element-" + attr_value + "-" + attribute_id;

    if ( attr_value == 'options' || attr_value == 'imageoptions' )
    {
        index = xrow_add_form_options( attr_value_id, ol_con_id, attribute_id, index, opt );
    }
    else
    {
        index = xrow_add_form_default( attr_value_id, ol_con_id, attribute_id, index, opt, attr_value );
    }

    return index;
}

function xrow_confirm( msg, id )
{
    if ( confirm( msg ) )
    {
        var formular = document.getElementById( id );
        return formular.submit();
    }
}
