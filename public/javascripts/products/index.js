/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 *
 * This code is written by Furqan Asghar
 * It's showing and hiding the tooltip on mouseenter and mouseleave respectively
 */


jQuery(function() {
    jQuery("#shiplist-send").mouseenter(function() {
        jQuery("#tooltip").show('blind');
    });
    jQuery("#shiplist-send").mouseleave(function() {
        jQuery("#tooltip").hide('blind');
    });
});