Class {
	#name : #ObjTestBootstrap,
	#superclass : #TestCase,
	#category : #'ObjV-AdvancedTests'
}

{ #category : #'test ObjClass creation' }
ObjTestBootstrap >> testCreateObjClassMessage [

	| objClass |
	Obj bootstrap.
	objClass := Obj giveClassNamed: #ObjClass.
	self 
		assert: (objClass send: #class withArguments: #())
		equals: (Obj giveClassNamed: #ObjClass).
	self assert: (objClass send: #isClass withArguments: #()).
	self assert: (objClass send: #isMetaclass withArguments: #())
]

{ #category : #'test ObjClass creation' }
ObjTestBootstrap >> testCreateObjClassStructure [

	| objClass |
	Obj bootstrap.
	objClass := Obj giveClassNamed: #ObjClass.
	self assert: objClass objName equals: #ObjClass.
	self assert: objClass objClassId equals: #ObjClass.
	self assert: objClass objSuperclassId equals: #ObjObject.
	self assert: objClass objIVs asArray equals: #(#class #name #superclass #iv #keywords #methodDict).
	self assert: objClass objKeywords asArray equals: #(#name: #superclass: #iv: #keywords: #methodDict:)
]

{ #category : #'test ObjObject creation ' }
ObjTestBootstrap >> testCreateObjObjectInstanceMessage [

	| pointClass objClass pointInstance |
	Obj initialize.
	Obj manuallyCreateObjClass.
	Obj createObjObject.
	objClass := Obj giveClassNamed: #ObjClass.
	pointClass := objClass
		              send: #new
		              withArguments:
		              #( #( #name: #ObjPoint #superclass: #ObjObject
		                    #iv: #( #x #y ) ) ).
	pointInstance := pointClass send: #new withArguments: #( #(  ) ).
	self assert: pointInstance objClassId equals: #ObjPoint.
	self
		assert: (pointInstance send: #getIV withArguments: #( #x ))
		equals: nil.
	pointInstance send: #setIV withArguments: #( #x 25 ).
	self
		assert: (pointInstance send: #getIV withArguments: #( x ))
		equals: 25
]

{ #category : #'test ObjObject creation ' }
ObjTestBootstrap >> testCreateObjObjectMessage [

	| objObject |
	Obj initialize.
	Obj manuallyCreateObjClass.
	Obj createObjObject.
	objObject := Obj giveClassNamed: #ObjObject.
	self assert: (objObject send: #class withArguments: #()) = (Obj giveClassNamed: #ObjClass).
	self assert: (objObject send: #isClass withArguments: #()) not.
	self assert: (objObject send: #getIV withArguments: #(#class)) = #ObjClass
]

{ #category : #'test ObjObject creation ' }
ObjTestBootstrap >> testCreateObjObjectStructure [

	| objObject |
	Obj initialize.
	Obj manuallyCreateObjClass.
	Obj createObjObject.
	objObject := Obj giveClassNamed: #ObjObject.
	self assert: (objObject objName = #ObjObject).
	self assert: (objObject objClassId = #ObjClass).
	self assert: (objObject objSuperclassId isNil).
	self assert: (objObject objIVs asArray = #(#class)).
	self assert: (objObject objKeywords asArray = #())
]

{ #category : #'test ObjClass manual creation' }
ObjTestBootstrap >> testManuallyCreateObjClassAllocate [

	| objClass emptyClass |
	Obj initialize.
	Obj manuallyCreateObjClass.
	objClass := Obj giveClassNamed: #ObjClass.
	emptyClass := objClass send: #allocate withArguments: #().
	self assert: emptyClass objClassId equals: #ObjClass.
	self assert: emptyClass objSuperclassId isNil.
	self assert: emptyClass objIVs isNil.
	self assert: emptyClass objKeywords isNil.
	self assert: emptyClass objMethodDict isNil.
	self assert: emptyClass objName isNil
]

{ #category : #'test ObjClass manual creation' }
ObjTestBootstrap >> testManuallyCreateObjClassStructure [

	| objClass |
	Obj initialize.
	Obj manuallyCreateObjClass.
	objClass := Obj giveClassNamed: #ObjClass.
	self assert: objClass objName equals: #ObjClass.
	self assert: objClass objClassId equals: #ObjClass.
	self assert: objClass objClass identicalTo: objClass.
	self assert: objClass objSuperclassId equals: #ObjObject.
	self
		assert: objClass objIVs
		equals: #( #class #name #superclass #iv #keywords #methodDict ).
	self
		assert: objClass objKeywords
		equals: #( #name: #superclass: #iv: #keywords: #methodDict: )
]
