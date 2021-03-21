USE PS_GameDefs
--removes apostrophes from these columns to help prevent failed log inserts
UPDATE dbo.Skills set SkillName=replace(SkillName,'''','');
UPDATE dbo.Mobs set MobName=replace(MobName,'''','');
UPDATE dbo.Items set ItemName=replace(ItemName,'''','');
