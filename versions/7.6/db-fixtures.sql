# Add your needed SQL Queries here!

# hide sys domains
UPDATE `sys_domain` SET `hidden` = '1';

# UPDATE `sys_template` SET `include_static_file` = 'EXT:fluid_styled_content/Configuration/TypoScript/,EXT:fluid_styled_content/Configuration/TypoScript/Styling/,EXT:tkflatmanager/Configuration/TypoScript,EXT:powermail/Configuration/TypoScript/Main,EXT:theme_web/Configuration/TypoScript/' WHERE `sys_template`.`uid` = 1;