UPDATE mst_Resource
SET ResourceValue = REPLACE(ResourceValue,'Seperation','Separation')
WHERE ResourceValue like '%Seperation%'


UPDATE mst_Resource
SET ResourceValue = REPLACE(ResourceValue,'Reson','Reason ')
WHERE ResourceValue like '%Reson%'


UPDATE mst_Resource
SET ResourceValue = REPLACE(ResourceValue,'Greter','Greater')
WHERE ResourceValue like '%Greter%'


UPDATE mst_Resource
SET ResourceValue = REPLACE(ResourceValue,'Disclsure','Disclosure')
WHERE ResourceValue like '%Disclsure%'


UPDATE mst_Resource
SET ResourceValue = REPLACE(ResourceValue,'Continous','Continuous')
WHERE ResourceValue like '%Continous%'


UPDATE mst_Resource
SET ResourceValue = REPLACE(ResourceValue,'Secuity','Security')
WHERE ResourceValue like '%Secuity%'




