<?php
//    MyDMS. Document Management System
//    Copyright (C) 2010 Matteo Lucarelli
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
include("../inc/inc.Language.php");
include("../inc/inc.Init.php");
include("../inc/inc.Extension.php");
include("../inc/inc.DBInit.php");
include("../inc/inc.ClassUI.php");
include("../inc/inc.Calendar.php");
include("../inc/inc.Authentication.php");

if ($user->isGuest()) {
	UI::exitError(getMLText("edit_event"),getMLText("access_denied"));
}

if (!isset($_GET["id"]) || !is_numeric($_GET["id"]) || intval($_GET["id"])<1) {
	UI::exitError(getMLText("edit_event"),getMLText("error_occured"));
}

$event=getEvent($_GET["id"]);

if (is_bool($event)&&!$event){
	UI::exitError(getMLText("edit_event"),getMLText("error_occured"));
}
if (($user->getID()!=$event["userID"])&&(!$user->isAdmin())){
	UI::exitError(getMLText("edit_event"),getMLText("access_denied"));
}

$tmp = explode('.', basename($_SERVER['SCRIPT_FILENAME']));
$view = UI::factory($theme, $tmp[1], array('dms'=>$dms, 'user'=>$user));
if($view) {
	$view->setParam('event', $event);
	$view->setParam('strictformcheck', $settings->_strictFormCheck);
	$view($_GET);
	exit;
}

?>
