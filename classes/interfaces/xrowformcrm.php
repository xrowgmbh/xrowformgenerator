<?php
interface xrowFormCRM
{
    /**
     * 
     */
    public function getCampaigns();
    public function getFields();
    public function setAttributeDataForCRMField( $data, $http, $id, $crm );
    public function setAttributeDataForCollectCRMField( $attributeContent, $key, $item, $inputContentCollection, $contentobject_id, $trans, $httpFieldType );
    public static function sendExportData( $objectAttribute, $collection );
}