-- ======================================================================================================
-- Author      : Vivek Mathur													
-- CREATED DATE: 09-JUN-2017                                                 							
-- Description : SCRIPTS FOR FORM E Axis bank template for table propery modification     											                =
-- ======================================================================================================

/* Update the Form E table content to use the full available width */
UPDATE tra_GeneratedFormDetails 
SET GeneratedFormContents = REPLACE(GeneratedFormContents,'<table border="1" cellpadding="0" cellspacing="0" style="width:943px">','<table border="1" cellpadding="0" cellspacing="0" style="width:100%">')

/* Update the template master Form E table content */
UPDATE tra_TemplateMaster SET Contents = REPLACE(Contents,'<table border="1" cellpadding="0" cellspacing="0" style="width:943px">','<table border="1" cellpadding="0" cellspacing="0" style="width:100%">')
WHERE TemplateName = 'Form E Template' AND IsActive = 1 AND CommunicationModeCodeId = 156007