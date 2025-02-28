# Update root Template
#UPDATE `sys_template` SET `include_static_file` = 'EXT:fluid_styled_content/Configuration/TypoScript/,EXT:fluid_styled_content/Configuration/TypoScript/Styling/,EXT:tkflatmanager/Configuration/TypoScript,EXT:powermail/Configuration/TypoScript/Main,EXT:theme_web/Configuration/TypoScript/' WHERE `sys_template`.`uid` = 1;

# Clean sys_template if using Site Sets
# TRUNCATE TABLE `sys_template`;

# ALTER TABLE `fe_users` CHANGE `image` `image` INT UNSIGNED DEFAULT 0 NULL
