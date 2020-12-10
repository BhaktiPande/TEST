DELETE FROM eve_EventWorkflow

INSERT INTO eve_EventWorkflow
(EventWorklowId, EventSetCodeId, EventCodeId, SequenceNumber)
VALUES
(1, 152001, 153001, 1),
(2, 152001, 153005, 2),
(3, 152001, 153027, 3),
(4, 152001, 153028, 4),
(5, 152001, 153008, 5),
(6, 152001, 153007, 6),
(7, 152001, 153009, 7),
(8, 152001, 153010, 8)









SELECT ewf.*, C.CodeName aS EventSet, cEvent.CodeName AS EventName
FROM eve_EventWorkflow EWf JOIN com_Code C ON ewf.EventSetCodeId = C.CodeID
JOIN com_Code cEvent ON ewf.EventCodeId = cEvent.CodeID
