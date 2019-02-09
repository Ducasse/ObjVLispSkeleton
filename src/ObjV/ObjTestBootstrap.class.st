Class {
	#name : #ObjTestBootstrap,
	#superclass : #TestCase,
	#category : #'ObjV-AdvancedTests'
}

{ #category : #'test ObjClass creation' }
ObjTestBootstrap >> testCreateObjClassMessage [
	"(self selector: #testCreateObjClassMessage) run"

	| objClass |
	Obj bootstrap.
	objClass := Obj giveClassNamed: #ObjClass.
	self assert: ((objClass send: #class withArguments: #()) = (Obj giveClassNamed: #ObjClass)).
	self assert: (objClass send: #isClass withArguments: #()).
	self assert: (objClass send: #isMetaclass withArguments: #())
]

{ #category : #'test ObjClass creation' }
ObjTestBootstrap >> testCreateObjClassStructure [
	"(self selector: #testCreateObjClassStructure) run"

	| objClass |
	Obj bootstrap.
	objClass := Obj giveClassNamed: #ObjClass.
	self assert: (objClass objName = #ObjClass).
	self assert: (objClass objClassId = #ObjClass).
	self assert: (objClass objSuperclassId = #ObjObject).
	self assert: (objClass objIVs asArray = #(#class #name #superclass #iv #keywords #methodDict)).
	self assert: (objClass objKeywords asArray = #(#name: #superclass: #iv: #keywords: #methodDict:))
]

{ #category : #'test ObjObject creation ' }
ObjTestBootstrap >> testCreateObjObjectInstanceMessage [
	"(self selector: #testCreateObjObjectInstanceMessage) run"

	| pointClass objClass pointInstance |
	Obj initialize.
	Obj manuallyCreateObjClass.
	Obj createObjObject.
	objClass := Obj giveClassNamed: #ObjClass.
	pointClass := objClass 
							send: #new
							withArguments: #(#(#name: #ObjPoint #superclass: #ObjObject #iv: #(#x #y))).
	pointInstance := pointClass send: #new withArguments: #(#()).
	self assert: (pointInstance objClassId = #ObjPoint).
	self assert: ((pointInstance send: #getIV withArguments: #(#x)) = nil).
	pointInstance send: #setIV withArguments: #(#x 25).
	self assert:  ((pointInstance send: #getIV withArguments: #(x)) = 25 )
]

{ #category : #'test ObjObject creation ' }
ObjTestBootstrap >> testCreateObjObjectMessage [
	"(self selector: #testCreateObjObjectMessage) run"

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
	"(self selector: #testCreateObjObjectStructure) run"

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

{ #category : #'test ObjClass manual creation ' }
ObjTestBootstrap >> testManuallyCreateObjClassAllocate [
	"(self selector: #testManuallyCreateObjClassAllocate) run"

	| objClass emptyClass |
	Obj initialize.
	Obj manuallyCreateObjClass.
	objClass := Obj giveClassNamed: #ObjClass.
	emptyClass := objClass send: #allocate withArguments: #().
	self assert: emptyClass objClassId = #ObjClass.
	self assert:  emptyClass objSuperclassId isNil.
	self assert:  emptyClass objIVs isNil.
	self assert:  emptyClass objKeywords isNil.
	self assert:  emptyClass objMethodDict isNil.
	self assert:  emptyClass objName isNil
]

{ #category : #'test ObjClass manual creation ' }
ObjTestBootstrap >> testManuallyCreateObjClassStructure [
	"(self selector: #testManuallyCreateObjClassStructure) run"

	| objClass |
	Obj initialize.
	Obj manuallyCreateObjClass.
	objClass := Obj giveClassNamed: #ObjClass.
	self assert: (objClass objName = #ObjClass).
	self assert: (objClass objClassId = #ObjClass).
	self assert: (objClass objClass == objClass).
	self assert: (objClass objSuperclassId = #ObjObject).	
	"the fact that the created first class inherits form ObjObject is not necessary
	because there is no super calls"
	self assert: (objClass objIVs = #(#class #name #superclass #iv #keywords #methodDict)).
	self assert: (objClass objKeywords = #(#name: #superclass: #iv: #keywords: #methodDict:))
]
