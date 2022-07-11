-- General atomic conversions:
-- The conversion has exactly one input and one output object.
--
-- InObj --> Conv --> OutObj
SELECT l.text node_name,
	(SELECT COUNT(*) FROM edge_item e
		WHERE (e.shape = 'dsl.edges.externalization'
			AND (e.source = n.id OR e.target = n.id))) exts,
	(SELECT COUNT(*) FROM edge_item e
		WHERE (e.shape = 'dsl.edges.socialization'
			AND (e.source = n.id OR e.target = n.id))) socs,
	(SELECT COUNT(*) FROM edge_item e
		WHERE (e.shape = 'dsl.edges.internalization'
			AND (e.source = n.id OR e.target = n.id))) ints,
	(SELECT COUNT(*) FROM edge_item e
		WHERE (e.shape = 'dsl.edges.combination'
			AND (e.source = n.id OR e.target = n.id))) combs,
	(SELECT COUNT(*) FROM edge_item e
		WHERE (e.shape = 'dsl.edges.undefined_conversion'
			AND (e.source = n.id OR e.target = n.id))) undefs
FROM node_item n
INNER JOIN view_model vm ON (vm.id = n.model)
INNER JOIN label_item l ON (l.node = n.id)
WHERE (
	n.shape = 'dsl.nodes.conversion' AND (
		1 = (SELECT COUNT(*) FROM edge_item WHERE target = n.id)
			AND 1 = (SELECT COUNT(*) FROM edge_item WHERE source = n.id)
	)
);

-- General complex conversions:
-- The conversion either has one input object and many output objects,
-- or it has many input objects and only one output object.
--
-- InObj1 -|
-- InObj2 -|-> Conv --> OutObj
-- ... ----|
-- InObjN -|
--
-- or
--
-- ................|-> OutObj1
-- InObj --> Conv -|-> OutObj2
-- ................|-> ...
-- ................|-> OutObjN
--
-- N >= 2
SELECT l.text node_name,
	(SELECT COUNT(*) FROM edge_item e
		WHERE (e.shape = 'dsl.edges.externalization'
			AND (e.source = n.id OR e.target = n.id))) exts,
	(SELECT COUNT(*) FROM edge_item e
		WHERE (e.shape = 'dsl.edges.socialization'
			AND (e.source = n.id OR e.target = n.id))) socs,
	(SELECT COUNT(*) FROM edge_item e
		WHERE (e.shape = 'dsl.edges.internalization'
			AND (e.source = n.id OR e.target = n.id))) ints,
	(SELECT COUNT(*) FROM edge_item e
		WHERE (e.shape = 'dsl.edges.combination'
			AND (e.source = n.id OR e.target = n.id))) combs,
	(SELECT COUNT(*) FROM edge_item e
		WHERE (e.shape = 'dsl.edges.undefined_conversion'
			AND (e.source = n.id OR e.target = n.id))) undefs
FROM node_item n
INNER JOIN view_model vm ON (vm.id = n.model)
INNER JOIN label_item l ON (l.node = n.id)
WHERE (
	n.shape = 'dsl.nodes.conversion' AND (
		(1 < (SELECT COUNT(*) FROM edge_item WHERE target = n.id)
			AND 1 = (SELECT COUNT(*) FROM edge_item WHERE source = n.id))
		OR 
		(1 = (SELECT COUNT(*) FROM edge_item WHERE target = n.id)
			AND 1 < (SELECT COUNT(*) FROM edge_item WHERE source = n.id))
	)
);

-- General abstract conversions:
-- The conversion has many input and many output objects.
--
-- InObj1 -|.........|-> OutObj1
-- InObj2 -|-> Conv -|-> OutObj2
-- ... ----|.........|-> ...
-- InObjN -|.........|-> OutObjN
--
-- N >= 2
SELECT l.text node_name,
	(SELECT COUNT(*) FROM edge_item e
		WHERE (e.shape = 'dsl.edges.externalization'
			AND (e.source = n.id OR e.target = n.id))) exts,
	(SELECT COUNT(*) FROM edge_item e
		WHERE (e.shape = 'dsl.edges.socialization'
			AND (e.source = n.id OR e.target = n.id))) socs,
	(SELECT COUNT(*) FROM edge_item e
		WHERE (e.shape = 'dsl.edges.internalization'
			AND (e.source = n.id OR e.target = n.id))) ints,
	(SELECT COUNT(*) FROM edge_item e
		WHERE (e.shape = 'dsl.edges.combination'
			AND (e.source = n.id OR e.target = n.id))) combs,
	(SELECT COUNT(*) FROM edge_item e
		WHERE (e.shape = 'dsl.edges.undefined_conversion'
			AND (e.source = n.id OR e.target = n.id))) undefs
FROM node_item n
INNER JOIN view_model vm ON (vm.id = n.model)
INNER JOIN label_item l ON (l.node = n.id)
WHERE (
	n.shape = 'dsl.nodes.conversion' AND (
		1 < (SELECT COUNT(*) FROM edge_item WHERE target = n.id)
			AND 1 < (SELECT COUNT(*) FROM edge_item WHERE source = n.id)
	)
);