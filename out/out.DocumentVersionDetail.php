<?php
//    MyDMS. Document Management System
//    Copyright (C) 2002-2005 Markus Westphal
//    Copyright (C) 2006-2008 Malcolm Cowe
//    Copyright (C) 2010 Matteo Lucarelli
//    Copyright (C) 2010-2016 Uwe Steinmann
//
//    This program is free software; you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation; either version 2 of the License, or
//    (at your option) any later version.
//
//    This program is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with this program; if not, write to the Free Software
//    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

include("../inc/inc.Settings.php");
include("../inc/inc.Utils.php");
include("../inc/inc.DBInit.php");
include("../inc/inc.Language.php");
include("../inc/inc.ClassUI.php");
include("../inc/inc.ClassAccessOperation.php");
include("../inc/inc.Authentication.php");

if (!isset($_GET["documentid"]) || !is_numeric($_GET["documentid"]) || intval($_GET["documentid"])<1) {
	UI::exitError(getMLText("document_title", array("documentname" => getMLText("invalid_doc_id"))),getMLText("invalid_doc_id"));
}

$document = $dms->getDocument($_GET["documentid"]);

if (!is_object($document)) {
	UI::exitError(getMLText("document_title", array("documentname" => getMLText("invalid_doc_id"))),getMLText("invalid_doc_id"));
}

if ($document->getAccessMode($user) < M_READ) {
	UI::exitError(getMLText("document_title", array("documentname" => htmlspecialchars($document->getName()))),getMLText("access_denied"));
}

if (!isset($_GET["version"]) || !is_numeric($_GET["version"]) || intval($_GET["version"])<1) {
	UI::exitError(getMLText("document_title", array("documentname" => htmlspecialchars($document->getName()))),getMLText("invalid_version"));
}

$version = $_GET["version"];
$version = $document->getContentByVersion($version);

if (!is_object($version)) {
	UI::exitError(getMLText("document_title", array("documentname" => htmlspecialchars($document->getName()))),getMLText("invalid_version"));
}

// if version is last got out.ViewDocument
$latestContent = $document->getLatestContent();
if ($latestContent->getVersion()==$version->getVersion()) {
	header("Location:../out/out.ViewDocument.php?documentid=".$document->getID());
	exit;
}

$folder = $document->getFolder();

/* Create object for checking access to certain operations */
$accessop = new SeedDMS_AccessOperation($document, $user, $settings);

$tmp = explode('.', basename($_SERVER['SCRIPT_FILENAME']));
$view = UI::factory($theme, $tmp[1], array('dms'=>$dms, 'user'=>$user));
if($view) {
	$view->setParam('folder', $folder);
	$view->setParam('document', $document);
	$view->setParam('version', $version);
	$view->setParam('viewonlinefiletypes', $settings->_viewOnlineFileTypes);
	$view->setParam('enableversionmodification', $settings->_enableVersionModification);
	$view->setParam('previewWidthDetail', $settings->_previewWidthDetail);
	$view->setParam('showFullPreview', $settings->_showFullPreview);
	$view->setParam('convertToPdf', $settings->_convertToPdf);
	$view->setParam('cachedir', $settings->_cacheDir);
	$view->setParam('timeout', $settings->_cmdTimeout);
	$view->setParam('accessobject', $accessop);
	$view($_GET);
	exit;
}

?>
