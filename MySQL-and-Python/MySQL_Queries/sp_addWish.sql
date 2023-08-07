USE BucketList;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_addWish`(
    IN p_title VARCHAR(255),
    IN p_description TEXT,
    IN p_user_id INT
)
BEGIN
    INSERT INTO tbl_wish (wish_title, wish_description, wish_user_id, wish_date)
    VALUES (p_title, p_description, p_user_id, NOW());
END$$
DELIMITER ;
