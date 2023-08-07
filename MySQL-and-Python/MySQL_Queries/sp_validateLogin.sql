USE BucketList;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_validateLogin`(IN p_username VARCHAR(100))  -- Update the length to 100 characters to match the column in tbl_user table
BEGIN
    SELECT user_id, user_name, user_username, user_password  -- Return the user_id, user_name, user_username, and user_password columns
    FROM tbl_user
    WHERE user_username = p_username;
END$$
DELIMITER ;