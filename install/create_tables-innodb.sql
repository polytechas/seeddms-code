-- 
-- Table structure for table `tblACLs`
-- 

CREATE TABLE `tblACLs` (
  `id` int(11) NOT NULL auto_increment,
  `target` int(11) NOT NULL default '0',
  `targetType` tinyint(4) NOT NULL default '0',
  `userID` int(11) NOT NULL default '-1',
  `groupID` int(11) NOT NULL default '-1',
  `mode` tinyint(4) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

-- 
-- Table structure for table `tblCategory`
-- 

CREATE TABLE `tblCategory` (
  `id` int(11) NOT NULL auto_increment,
  `name` text NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

-- 
-- Table structure for table `tblAttributeDefinitions`
-- 

CREATE TABLE `tblAttributeDefinitions` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(100) default NULL,
  `objtype` tinyint(4) NOT NULL default '0',
  `type` tinyint(4) NOT NULL default '0',
  `multiple` tinyint(4) NOT NULL default '0',
  `minvalues` int(11) NOT NULL default '0',
  `maxvalues` int(11) NOT NULL default '0',
  `valueset` text default NULL,
  `regex` text default NULL,
  UNIQUE(`name`),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

-- 
-- Table structure for table `tblUsers`
-- 

CREATE TABLE `tblRoles` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(50) default NULL,
  `role` smallint(1) NOT NULL default '0',
  `noaccess` varchar(30) NOT NULL default '',
  PRIMARY KEY (`id`),
  UNIQUE (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

-- 
-- Table structure for table `tblUsers`
-- 

CREATE TABLE `tblUsers` (
  `id` int(11) NOT NULL auto_increment,
  `login` varchar(50) default NULL,
  `pwd` varchar(50) default NULL,
  `fullName` varchar(100) default NULL,
  `email` varchar(70) default NULL,
  `language` varchar(32) NOT NULL,
  `theme` varchar(32) NOT NULL,
  `comment` text NOT NULL,
  `role` int(11) NOT NULL,
  `hidden` smallint(1) NOT NULL default '0',
  `pwdExpiration` datetime NOT NULL default '0000-00-00 00:00:00',
  `loginfailures` tinyint(4) NOT NULL default '0',
  `disabled` smallint(1) NOT NULL default '0',
  `quota` bigint,
  `homefolder` int(11) default NULL,
  PRIMARY KEY (`id`),
  UNIQUE (`login`),
  CONSTRAINT `tblUsers_role` FOREIGN KEY (`role`) REFERENCES `tblRoles` (`id`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

-- 
-- Table structure for table `tblUserSubstitutes`
-- 

CREATE TABLE `tblUserSubstitutes` (
  `id` int(11) NOT NULL auto_increment,
  `user` int(11) default null,
  `substitute` int(11) default null,
  PRIMARY KEY (`id`),
  UNIQUE (`user`, `substitute`),
  CONSTRAINT `tblUserSubstitutes_user` FOREIGN KEY (`user`) REFERENCES `tblUsers` (`id`) ON DELETE CASCADE,
  CONSTRAINT `tblUserSubstitutes_substitute` FOREIGN KEY (`user`) REFERENCES `tblUsers` (`id`) ON DELETE CASCADE
);

-- --------------------------------------------------------

-- 
-- Table structure for table `tblUserPasswordRequest`
-- 

CREATE TABLE `tblUserPasswordRequest` (
  `id` int(11) NOT NULL auto_increment,
  `userID` int(11) NOT NULL default '0',
  `hash` varchar(50) default NULL,
  `date` datetime NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (`id`),
  CONSTRAINT `tblUserPasswordRequest_user` FOREIGN KEY (`userID`) REFERENCES `tblUsers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

-- 
-- Table structure for table `tblUserPasswordHistory`
-- 

CREATE TABLE `tblUserPasswordHistory` (
  `id` int(11) NOT NULL auto_increment,
  `userID` int(11) NOT NULL default '0',
  `pwd` varchar(50) default NULL,
  `date` datetime NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (`id`),
  CONSTRAINT `tblUserPasswordHistory_user` FOREIGN KEY (`userID`) REFERENCES `tblUsers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

-- 
-- Table structure for table `tblUserImages`
-- 

CREATE TABLE `tblUserImages` (
  `id` int(11) NOT NULL auto_increment,
  `userID` int(11) NOT NULL default '0',
  `image` blob NOT NULL,
  `mimeType` varchar(10) NOT NULL default '',
  PRIMARY KEY  (`id`),
  CONSTRAINT `tblUserImages_user` FOREIGN KEY (`userID`) REFERENCES `tblUsers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

-- 
-- Table structure for table `tblFolders`
-- 

CREATE TABLE `tblFolders` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(70) default NULL,
  `parent` int(11) default NULL,
  `folderList` text NOT NULL,
  `comment` text,
  `date` int(12) default NULL,
  `owner` int(11) default NULL,
  `inheritAccess` tinyint(1) NOT NULL default '1',
  `defaultAccess` tinyint(4) NOT NULL default '0',
  `sequence` double NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `parent` (`parent`),
  CONSTRAINT `tblFolders_owner` FOREIGN KEY (`owner`) REFERENCES `tblUsers` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE tblUsers ADD CONSTRAINT `tblUsers_homefolder` FOREIGN KEY (`homefolder`) REFERENCES `tblFolders` (`id`);

-- --------------------------------------------------------

-- 
-- Table structure for table `tblFolderAttributes`
-- 

CREATE TABLE `tblFolderAttributes` (
  `id` int(11) NOT NULL auto_increment,
  `folder` int(11) default NULL,
  `attrdef` int(11) default NULL,
  `value` text default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE (folder, attrdef),
  CONSTRAINT `tblFolderAttributes_folder` FOREIGN KEY (`folder`) REFERENCES `tblFolders` (`id`) ON DELETE CASCADE,
  CONSTRAINT `tblFolderAttributes_attrdef` FOREIGN KEY (`attrdef`) REFERENCES `tblAttributeDefinitions` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

-- 
-- Table structure for table `tblDocuments`
-- 

CREATE TABLE `tblDocuments` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(150) default NULL,
  `comment` text,
  `date` int(12) default NULL,
  `expires` int(12) default NULL,
  `owner` int(11) default NULL,
  `folder` int(11) default NULL,
  `folderList` text NOT NULL,
  `inheritAccess` tinyint(1) NOT NULL default '1',
  `defaultAccess` tinyint(4) NOT NULL default '0',
  `locked` int(11) NOT NULL default '-1',
  `keywords` text NOT NULL,
  `sequence` double NOT NULL default '0',
  PRIMARY KEY  (`id`),
  CONSTRAINT `tblDocuments_folder` FOREIGN KEY (`folder`) REFERENCES `tblFolders` (`id`),
  CONSTRAINT `tblDocuments_owner` FOREIGN KEY (`owner`) REFERENCES `tblUsers` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

-- 
-- Table structure for table `tblDocumentAttributes`
-- 

CREATE TABLE `tblDocumentAttributes` (
  `id` int(11) NOT NULL auto_increment,
  `document` int(11) default NULL,
  `attrdef` int(11) default NULL,
  `value` text default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE (document, attrdef),
  CONSTRAINT `tblDocumentAttributes_document` FOREIGN KEY (`document`) REFERENCES `tblDocuments` (`id`) ON DELETE CASCADE,
  CONSTRAINT `tblDocumentAttributes_attrdef` FOREIGN KEY (`attrdef`) REFERENCES `tblAttributeDefinitions` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

-- 
-- Table structure for table `tblDocumentApprovers`
-- 

CREATE TABLE `tblDocumentApprovers` (
  `approveID` int(11) NOT NULL auto_increment,
  `documentID` int(11) NOT NULL default '0',
  `version` smallint(5) unsigned NOT NULL default '0',
  `type` tinyint(4) NOT NULL default '0',
  `required` int(11) NOT NULL default '0',
  PRIMARY KEY  (`approveID`),
  UNIQUE KEY `documentID` (`documentID`,`version`,`type`,`required`),
  CONSTRAINT `tblDocumentApprovers_document` FOREIGN KEY (`documentID`) REFERENCES `tblDocuments` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

-- 
-- Table structure for table `tblDocumentApproveLog`
-- 

CREATE TABLE `tblDocumentApproveLog` (
  `approveLogID` int(11) NOT NULL auto_increment,
  `approveID` int(11) NOT NULL default '0',
  `status` tinyint(4) NOT NULL default '0',
  `comment` text NOT NULL,
  `date` datetime NOT NULL default '0000-00-00 00:00:00',
  `userID` int(11) NOT NULL default '0',
  PRIMARY KEY  (`approveLogID`),
  CONSTRAINT `tblDocumentApproveLog_approve` FOREIGN KEY (`approveID`) REFERENCES `tblDocumentApprovers` (`approveID`) ON DELETE CASCADE,
  CONSTRAINT `tblDocumentApproveLog_user` FOREIGN KEY (`userID`) REFERENCES `tblUsers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

-- 
-- Table structure for table `tblDocumentContent`
-- 

CREATE TABLE `tblDocumentContent` (
  `id` int(11) NOT NULL auto_increment,
  `document` int(11) NOT NULL default '0',
  `version` smallint(5) unsigned NOT NULL,
  `comment` text,
  `date` int(12) default NULL,
  `createdBy` int(11) default NULL,
  `dir` varchar(255) NOT NULL default '',
  `orgFileName` varchar(150) NOT NULL default '',
  `fileType` varchar(10) NOT NULL default '',
  `mimeType` varchar(100) NOT NULL default '',
  `fileSize` BIGINT,
  `checksum` char(32),
  `revisiondate` datetime default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE (`document`, `version`),
  CONSTRAINT `tblDocumentContent_document` FOREIGN KEY (`document`) REFERENCES `tblDocuments` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

-- 
-- Table structure for table `tblDocumentContentAttributes`
-- 

CREATE TABLE `tblDocumentContentAttributes` (
  `id` int(11) NOT NULL auto_increment,
  `content` int(11) default NULL,
  `attrdef` int(11) default NULL,
  `value` text default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE (content, attrdef),
  CONSTRAINT `tblDocumentContentAttributes_document` FOREIGN KEY (`content`) REFERENCES `tblDocumentContent` (`id`) ON DELETE CASCADE,
  CONSTRAINT `tblDocumentContentAttributes_attrdef` FOREIGN KEY (`attrdef`) REFERENCES `tblAttributeDefinitions` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

-- 
-- Table structure for table `tblDocumentLinks`
-- 

CREATE TABLE `tblDocumentLinks` (
  `id` int(11) NOT NULL auto_increment,
  `document` int(11) NOT NULL default '0',
  `target` int(11) NOT NULL default '0',
  `userID` int(11) NOT NULL default '0',
  `public` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  CONSTRAINT `tblDocumentLinks_document` FOREIGN KEY (`document`) REFERENCES `tblDocuments` (`id`) ON DELETE CASCADE,
  CONSTRAINT `tblDocumentLinks_target` FOREIGN KEY (`target`) REFERENCES `tblDocuments` (`id`) ON DELETE CASCADE,
  CONSTRAINT `tblDocumentLinks_user` FOREIGN KEY (`userID`) REFERENCES `tblUsers` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

-- 
-- Table structure for table `tblDocumentFiles`
-- 

CREATE TABLE `tblDocumentFiles` (
  `id` int(11) NOT NULL auto_increment,
  `document` int(11) NOT NULL default '0',
  `userID` int(11) NOT NULL default '0',
  `comment` text,
  `name` varchar(150) default NULL,
  `date` int(12) default NULL,
  `dir` varchar(255) NOT NULL default '',
  `orgFileName` varchar(150) NOT NULL default '',
  `fileType` varchar(10) NOT NULL default '',
  `mimeType` varchar(100) NOT NULL default '',  
  PRIMARY KEY  (`id`),
  CONSTRAINT `tblDocumentFiles_document` FOREIGN KEY (`document`) REFERENCES `tblDocuments` (`id`) ON DELETE CASCADE,
  CONSTRAINT `tblDocumentFiles_user` FOREIGN KEY (`userID`) REFERENCES `tblUsers` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



-- --------------------------------------------------------

-- 
-- Table structure for table `tblDocumentLocks`
-- 

CREATE TABLE `tblDocumentLocks` (
  `document` int(11) NOT NULL default '0',
  `userID` int(11) NOT NULL default '0',
  PRIMARY KEY  (`document`),
  CONSTRAINT `tblDocumentLocks_document` FOREIGN KEY (`document`) REFERENCES `tblDocuments` (`id`) ON DELETE CASCADE,
  CONSTRAINT `tblDocumentLocks_user` FOREIGN KEY (`userID`) REFERENCES `tblUsers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

-- 
-- Table structure for table `tblDocumentCheckOuts`
-- 

CREATE TABLE `tblDocumentCheckOuts` (
  `document` int(11) NOT NULL default '0',
  `version` smallint(5) unsigned NOT NULL default '0',
  `userID` int(11) NOT NULL default '0',
  `date` datetime NOT NULL default '0000-00-00 00:00:00',
  `filename` varchar(255) NOT NULL default '',
  PRIMARY KEY  (`document`),
  CONSTRAINT `tblDocumentCheckOuts_document` FOREIGN KEY (`document`) REFERENCES `tblDocuments` (`id`) ON DELETE CASCADE,
  CONSTRAINT `tblDocumentCheckOuts_user` FOREIGN KEY (`userID`) REFERENCES `tblUsers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

-- 
-- Table structure for table `tblDocumentReviewers`
-- 

CREATE TABLE `tblDocumentReviewers` (
  `reviewID` int(11) NOT NULL auto_increment,
  `documentID` int(11) NOT NULL default '0',
  `version` smallint(5) unsigned NOT NULL default '0',
  `type` tinyint(4) NOT NULL default '0',
  `required` int(11) NOT NULL default '0',
  PRIMARY KEY  (`reviewID`),
  UNIQUE KEY `documentID` (`documentID`,`version`,`type`,`required`),
  CONSTRAINT `tblDocumentReviewers_document` FOREIGN KEY (`documentID`) REFERENCES `tblDocuments` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

-- 
-- Table structure for table `tblDocumentReviewLog`
-- 

CREATE TABLE `tblDocumentReviewLog` (
  `reviewLogID` int(11) NOT NULL auto_increment,
  `reviewID` int(11) NOT NULL default '0',
  `status` tinyint(4) NOT NULL default '0',
  `comment` text NOT NULL,
  `date` datetime NOT NULL default '0000-00-00 00:00:00',
  `userID` int(11) NOT NULL default '0',
  PRIMARY KEY  (`reviewLogID`),
  CONSTRAINT `tblDocumentReviewLog_review` FOREIGN KEY (`reviewID`) REFERENCES `tblDocumentReviewers` (`reviewID`) ON DELETE CASCADE,
  CONSTRAINT `tblDocumentReviewLog_user` FOREIGN KEY (`userID`) REFERENCES `tblUsers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

-- 
-- Table structure for table `tblDocumentRecipients`
-- 

CREATE TABLE `tblDocumentRecipients` (
  `receiptID` int(11) NOT NULL auto_increment,
  `documentID` int(11) NOT NULL default '0',
  `version` smallint(5) unsigned NOT NULL default '0',
  `type` tinyint(4) NOT NULL default '0',
  `required` int(11) NOT NULL default '0',
  PRIMARY KEY  (`receiptID`),
  UNIQUE KEY `documentID` (`documentID`,`version`,`type`,`required`),
  CONSTRAINT `tblDocumentRecipients_document` FOREIGN KEY (`documentID`) REFERENCES `tblDocuments` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

-- 
-- Table structure for table `tblDocumentReceiptLog`
-- 

CREATE TABLE `tblDocumentReceiptLog` (
  `receiptLogID` int(11) NOT NULL auto_increment,
  `receiptID` int(11) NOT NULL default '0',
  `status` tinyint(4) NOT NULL default '0',
  `comment` text NOT NULL,
  `date` datetime NOT NULL default '0000-00-00 00:00:00',
  `userID` int(11) NOT NULL default '0',
  PRIMARY KEY  (`receiptLogID`),
  CONSTRAINT `tblDocumentReceiptLog_recipient` FOREIGN KEY (`receiptID`) REFERENCES `tblDocumentRecipients` (`receiptID`) ON DELETE CASCADE,
  CONSTRAINT `tblDocumentReceiptLog_user` FOREIGN KEY (`userID`) REFERENCES `tblUsers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

-- 
-- Table structure for table `tblDocumentRevisors`
-- 

CREATE TABLE `tblDocumentRevisors` (
  `revisionID` int(11) NOT NULL auto_increment,
  `documentID` int(11) NOT NULL default '0',
  `version` smallint(5) unsigned NOT NULL default '0',
  `type` tinyint(4) NOT NULL default '0',
  `required` int(11) NOT NULL default '0',
  `startdate` datetime default NULL,
  PRIMARY KEY  (`revisionID`),
  UNIQUE KEY `documentID` (`documentID`,`version`,`type`,`required`),
  CONSTRAINT `tblDocumentRevisors_document` FOREIGN KEY (`documentID`) REFERENCES `tblDocuments` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

-- 
-- Table structure for table `tblDocumentRevisionLog`
-- 

CREATE TABLE `tblDocumentRevisionLog` (
  `revisionLogID` int(11) NOT NULL auto_increment,
  `revisionID` int(11) NOT NULL default '0',
  `status` tinyint(4) NOT NULL default '0',
  `comment` text NOT NULL,
  `date` datetime NOT NULL default '0000-00-00 00:00:00',
  `userID` int(11) NOT NULL default '0',
  PRIMARY KEY  (`revisionLogID`),
  CONSTRAINT `tblDocumentRevisionLog_revision` FOREIGN KEY (`revisionID`) REFERENCES `tblDocumentRevisors` (`revisionID`) ON DELETE CASCADE,
  CONSTRAINT `tblDocumentRevisionLog_user` FOREIGN KEY (`userID`) REFERENCES `tblUsers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------
-- 
-- Table structure for table `tblDocumentStatus`
-- 

CREATE TABLE `tblDocumentStatus` (
  `statusID` int(11) NOT NULL auto_increment,
  `documentID` int(11) NOT NULL default '0',
  `version` smallint(5) unsigned NOT NULL default '0',
  PRIMARY KEY  (`statusID`),
  UNIQUE KEY `documentID` (`documentID`,`version`),
  CONSTRAINT `tblDocumentStatus_document` FOREIGN KEY (`documentID`) REFERENCES `tblDocuments` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

-- 
-- Table structure for table `tblDocumentStatusLog`
-- 

CREATE TABLE `tblDocumentStatusLog` (
  `statusLogID` int(11) NOT NULL auto_increment,
  `statusID` int(11) NOT NULL default '0',
  `status` tinyint(4) NOT NULL default '0',
  `comment` text NOT NULL,
  `date` datetime NOT NULL default '0000-00-00 00:00:00',
  `userID` int(11) NOT NULL default '0',
  PRIMARY KEY  (`statusLogID`),
  KEY `statusID` (`statusID`),
  CONSTRAINT `tblDocumentStatusLog_status` FOREIGN KEY (`statusID`) REFERENCES `tblDocumentStatus` (`statusID`) ON DELETE CASCADE,
  CONSTRAINT `tblDocumentStatusLog_user` FOREIGN KEY (`userID`) REFERENCES `tblUsers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

-- 
-- Table structure for table `tblGroups`
-- 

CREATE TABLE `tblGroups` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(50) default NULL,
  `comment` text NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

-- 
-- Table structure for table `tblGroupMembers`
-- 

CREATE TABLE `tblGroupMembers` (
  `groupID` int(11) NOT NULL default '0',
  `userID` int(11) NOT NULL default '0',
  `manager` smallint(1) NOT NULL default '0',
  UNIQUE (`groupID`,`userID`),
  CONSTRAINT `tblGroupMembers_user` FOREIGN KEY (`userID`) REFERENCES `tblUsers` (`id`) ON DELETE CASCADE,
  CONSTRAINT `tblGroupMembers_group` FOREIGN KEY (`groupID`) REFERENCES `tblGroups` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

-- 
-- Table structure for table `tblKeywordCategories`
-- 

CREATE TABLE `tblKeywordCategories` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) NOT NULL default '',
  `owner` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

-- 
-- Table structure for table `tblKeywords`
-- 

CREATE TABLE `tblKeywords` (
  `id` int(11) NOT NULL auto_increment,
  `category` int(11) NOT NULL default '0',
  `keywords` text NOT NULL,
  PRIMARY KEY  (`id`),
  CONSTRAINT `tblKeywords_category` FOREIGN KEY (`category`) REFERENCES `tblKeywordCategories` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

-- 
-- Table structure for table `tblDocumentCategory`
-- 

CREATE TABLE `tblDocumentCategory` (
  `categoryID` int(11) NOT NULL default 0,
  `documentID` int(11) NOT NULL default 0,
  CONSTRAINT `tblDocumentCategory_category` FOREIGN KEY (`categoryID`) REFERENCES `tblCategory` (`id`) ON DELETE CASCADE,
  CONSTRAINT `tblDocumentCategory_document` FOREIGN KEY (`documentID`) REFERENCES `tblDocuments` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

-- 
-- Table structure for table `tblNotify`
-- 

CREATE TABLE `tblNotify` (
  `target` int(11) NOT NULL default '0',
  `targetType` int(11) NOT NULL default '0',
  `userID` int(11) NOT NULL default '-1',
  `groupID` int(11) NOT NULL default '-1',
  PRIMARY KEY  (`target`,`targetType`,`userID`,`groupID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

-- 
-- Table structure for table `tblSessions`
-- 

CREATE TABLE `tblSessions` (
  `id` varchar(50) NOT NULL default '',
  `userID` int(11) NOT NULL default '0',
  `lastAccess` int(11) NOT NULL default '0',
  `theme` varchar(30) NOT NULL default '',
  `language` varchar(30) NOT NULL default '',
  `clipboard` text default '',
  `su` INTEGER DEFAULT NULL,
  `splashmsg` text default '',
  PRIMARY KEY  (`id`),
  CONSTRAINT `tblSessions_user` FOREIGN KEY (`userID`) REFERENCES `tblUsers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

-- 
-- Table structure for mandatory reviewers
-- 

CREATE TABLE `tblMandatoryReviewers` (
  `userID` int(11) NOT NULL default '0',
  `reviewerUserID` int(11) NOT NULL default '0',
  `reviewerGroupID` int(11) NOT NULL default '0',
  PRIMARY KEY  (`userID`,`reviewerUserID`,`reviewerGroupID`),
  CONSTRAINT `tblMandatoryReviewers_user` FOREIGN KEY (`userID`) REFERENCES `tblUsers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

-- 
-- Table structure for mandatory approvers
-- 

CREATE TABLE `tblMandatoryApprovers` (
  `userID` int(11) NOT NULL default '0',
  `approverUserID` int(11) NOT NULL default '0',
  `approverGroupID` int(11) NOT NULL default '0',
  PRIMARY KEY  (`userID`,`approverUserID`,`approverGroupID`),
  CONSTRAINT `tblMandatoryApprovers_user` FOREIGN KEY (`userID`) REFERENCES `tblUsers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

-- 
-- Table structure for events (calendar)
-- 

CREATE TABLE `tblEvents` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(150) default NULL,
  `comment` text,
  `start` int(12) default NULL,
  `stop` int(12) default NULL,
  `date` int(12) default NULL,
  `userID` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

-- 
-- Table structure for workflow states
-- 

CREATE TABLE tblWorkflowStates (
  `id` int(11) NOT NULL auto_increment,
  `name` text NOT NULL,
  `visibility` smallint(5) DEFAULT 0,
  `maxtime` int(11) DEFAULT 0,
  `precondfunc` text DEFAULT NULL,
  `documentstatus` smallint(5) DEFAULT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

-- 
-- Table structure for workflow actions
-- 

CREATE TABLE tblWorkflowActions (
  `id` int(11) NOT NULL auto_increment,
  `name` text NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

-- 
-- Table structure for workflows
-- 

CREATE TABLE tblWorkflows (
  `id` int(11) NOT NULL auto_increment,
  `name` text NOT NULL,
  `initstate` int(11) NOT NULL,
  PRIMARY KEY  (`id`),
  CONSTRAINT `tblWorkflow_initstate` FOREIGN KEY (`initstate`) REFERENCES `tblWorkflowStates` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

-- 
-- Table structure for workflow transitions
-- 

CREATE TABLE tblWorkflowTransitions (
  `id` int(11) NOT NULL auto_increment,
  `workflow` int(11) default NULL,
  `state` int(11) default NULL,
  `action` int(11) default NULL,
  `nextstate` int(11) default NULL,
  `maxtime` int(11) DEFAULT 0,
  PRIMARY KEY  (`id`),
  CONSTRAINT `tblWorkflowTransitions_workflow` FOREIGN KEY (`workflow`) REFERENCES `tblWorkflows` (`id`) ON DELETE CASCADE,
  CONSTRAINT `tblWorkflowTransitions_state` FOREIGN KEY (`state`) REFERENCES `tblWorkflowStates` (`id`) ON DELETE CASCADE,
  CONSTRAINT `tblWorkflowTransitions_action` FOREIGN KEY (`action`) REFERENCES `tblWorkflowActions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `tblWorkflowTransitions_nextstate` FOREIGN KEY (`nextstate`) REFERENCES `tblWorkflowStates` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

-- 
-- Table structure for workflow transition users
-- 

CREATE TABLE tblWorkflowTransitionUsers (
  `id` int(11) NOT NULL auto_increment,
  `transition` int(11) default NULL,
  `userid` int(11) default NULL,
  PRIMARY KEY  (`id`),
  CONSTRAINT `tblWorkflowTransitionUsers_transition` FOREIGN KEY (`transition`) REFERENCES `tblWorkflowTransitions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `tblWorkflowTransitionUsers_userid` FOREIGN KEY (`userid`) REFERENCES `tblUsers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

-- 
-- Table structure for workflow transition groups
-- 

CREATE TABLE tblWorkflowTransitionGroups (
  `id` int(11) NOT NULL auto_increment,
  `transition` int(11) default NULL,
  `groupid` int(11) default NULL,
  `minusers` int(11) default NULL,
  PRIMARY KEY  (`id`),
  CONSTRAINT `tblWorkflowTransitionGroups_transition` FOREIGN KEY (`transition`) REFERENCES `tblWorkflowTransitions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `tblWorkflowTransitionGroups_groupid` FOREIGN KEY (`groupID`) REFERENCES `tblGroups` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

-- 
-- Table structure for workflow log
-- 

CREATE TABLE tblWorkflowLog (
  `id` int(11) NOT NULL auto_increment,
  `document` int(11) default NULL,
  `version` smallint(5) default NULL,
  `workflow` int(11) default NULL,
  `userid` int(11) default NULL,
  `transition` int(11) default NULL,
  `date` datetime NOT NULL default '0000-00-00 00:00:00',
  `comment` text,
  PRIMARY KEY  (`id`),
  CONSTRAINT `tblWorkflowLog_document` FOREIGN KEY (`document`) REFERENCES `tblDocuments` (`id`) ON DELETE CASCADE,
  CONSTRAINT `tblWorkflowLog_workflow` FOREIGN KEY (`workflow`) REFERENCES `tblWorkflows` (`id`) ON DELETE CASCADE,
  CONSTRAINT `tblWorkflowLog_userid` FOREIGN KEY (`userid`) REFERENCES `tblUsers` (`id`) ON DELETE CASCADE,
  CONSTRAINT `tblWorkflowLog_transition` FOREIGN KEY (`transition`) REFERENCES `tblWorkflowTransitions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

-- 
-- Table structure for workflow document relation
-- 

CREATE TABLE tblWorkflowDocumentContent (
  `parentworkflow` int(11) DEFAULT 0,
  `workflow` int(11) DEFAULT NULL,
  `document` int(11) DEFAULT NULL,
  `version` smallint(5) DEFAULT NULL,
  `state` int(11) DEFAULT NULL,
  `date` datetime NOT NULL default '0000-00-00 00:00:00',
  CONSTRAINT `tblWorkflowDocument_document` FOREIGN KEY (`document`) REFERENCES `tblDocuments` (`id`) ON DELETE CASCADE,
  CONSTRAINT `tblWorkflowDocument_workflow` FOREIGN KEY (`workflow`) REFERENCES `tblWorkflows` (`id`) ON DELETE CASCADE,
  CONSTRAINT `tblWorkflowDocument_state` FOREIGN KEY (`state`) REFERENCES `tblWorkflowStates` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

-- 
-- Table structure for mandatory workflows
-- 

CREATE TABLE tblWorkflowMandatoryWorkflow (
  `userid` int(11) default NULL,
  `workflow` int(11) default NULL,
  UNIQUE(userid, workflow),
  CONSTRAINT `tblWorkflowMandatoryWorkflow_workflow` FOREIGN KEY (`workflow`) REFERENCES `tblWorkflows` (`id`) ON DELETE CASCADE,
  CONSTRAINT `tblWorkflowMandatoryWorkflow_userid` FOREIGN KEY (`userid`) REFERENCES `tblUsers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

-- 
-- Table structure for transmittal
-- 

CREATE TABLE `tblTransmittals` (
  `id` int(11) NOT NULL auto_increment,
  `name` text NOT NULL,
  `comment` text NOT NULL,
  `userID` int(11) NOT NULL default '0',
  `date` datetime,
  `public` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  CONSTRAINT `tblTransmittals_user` FOREIGN KEY (`userID`) REFERENCES `tblUsers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

-- 
-- Table structure for transmittal item
-- 

CREATE TABLE `tblTransmittalItems` (
  `id` int(11) NOT NULL auto_increment,
  `transmittal` int(11) NOT NULL DEFAULT '0',
  `document` int(11) default NULL,
  `version` smallint(5) unsigned NOT NULL default '0',
  `date` datetime,
  PRIMARY KEY  (`id`),
  UNIQUE (document, version),
  CONSTRAINT `tblTransmittalItems_document` FOREIGN KEY (`document`) REFERENCES `tblDocuments` (`id`) ON DELETE CASCADE,
  CONSTRAINT `tblTransmittalItem_transmittal` FOREIGN KEY (`transmittal`) REFERENCES `tblTransmittals` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

-- 
-- Table structure for cached read access
-- 

CREATE TABLE `tblCachedAccess` (
  `id` int(11) NOT NULL auto_increment,
  `document` int(11) default NULL,
  `user` int(11) default null,
  `mode` tinyint(4) NOT NULL default '0',
  PRIMARY KEY (`id`),
  CONSTRAINT `tblCachedAccess_document` FOREIGN KEY (`document`) REFERENCES `tblDocuments` (`id`) ON DELETE CASCADE,
  CONSTRAINT `tblCachedAccess_user` FOREIGN KEY (`user`) REFERENCES `tblUsers` (`id`) ON DELETE CASCADE,
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

-- 
-- Table structure for access request objects
-- 

CREATE TABLE `tblAros` (
  `id` int(11) NOT NULL auto_increment,
  `parent` int(11),
  `model` text NOT NULL,
  `foreignid` int(11) NOT NULL DEFAULT '0',
  `alias` varchar(255),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

-- 
-- Table structure for access control objects
-- 

CREATE TABLE `tblAcos` (
  `id` int(11) NOT NULL auto_increment,
  `parent` int(11),
  `model` text NOT NULL,
  `foreignid` int(11) NOT NULL DEFAULT '0',
  `alias` varchar(255),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

-- 
-- Table structure for acos/aros relation
-- 

CREATE TABLE `tblArosAcos` (
  `id` int(11) NOT NULL auto_increment,
  `aro` int(11) NOT NULL DEFAULT '0',
  `aco` int(11) NOT NULL DEFAULT '0',
  `create` tinyint(4) NOT NULL DEFAULT '-1',
  `read` tinyint(4) NOT NULL DEFAULT '-1',
  `update` tinyint(4) NOT NULL DEFAULT '-1',
  `delete` tinyint(4) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  UNIQUE (aco, aro),
  CONSTRAINT `tblArosAcos_acos` FOREIGN KEY (`aco`) REFERENCES `tblAcos` (`id`) ON DELETE CASCADE,
  CONSTRAINT `tblArosAcos_aros` FOREIGN KEY (`aro`) REFERENCES `tblAros` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

-- 
-- Table structure for version
-- 

CREATE TABLE `tblVersion` (
  `date` datetime,
  `major` smallint,
  `minor` smallint,
  `subminor` smallint
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Initial content for database
--

INSERT INTO tblUsers VALUES (1, 'admin', '21232f297a57a5a743894a0e4a801fc3', 'Administrator', 'address@server.com', '', '', '', 1, 0, '0000-00-00 00:00:00', 0, 0, 0, NULL);
INSERT INTO tblUsers VALUES (2, 'guest', NULL, 'Guest User', NULL, '', '', '', 2, 0, '0000-00-00 00:00:00', 0, 0, 0, NULL);
INSERT INTO tblFolders VALUES (1, 'DMS', 0, '', 'DMS root', UNIX_TIMESTAMP(), 1, 0, 2, 0);
INSERT INTO tblVersion VALUES (NOW(), 5, 0, 0);
INSERT INTO tblCategory VALUES (0, '');
