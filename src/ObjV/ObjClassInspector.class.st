"
I'm a simple inspector that can inspect fixed structured Obj class.

""creating class by hand""

| coloredPointClass |
coloredPointClass := Obj new: 6.
coloredPointClass at: coloredPointClass offsetForName put: #ObjColoredPoint.
coloredPointClass at: coloredPointClass offsetForClass put: #ObjClass.
coloredPointClass at: coloredPointClass offsetForIVs put: #( #class #x #y #color).
coloredPointClass at: coloredPointClass offsetForSuperclass put: #ObjPoint.
coloredPointClass at: coloredPointClass offsetForMethodDict	put: (IdentityDictionary new).
coloredPointClass.

ObjClassInspector basicInspect: coloredPointClass.


"
Class {
	#name : #ObjClassInspector,
	#superclass : #EyeCollectionInspector,
	#type : #variable,
	#category : #'ObjV-Inspector'
}

{ #category : #list }
ObjClassInspector >> addVariableFields: elements [
	
	| classStructure |
	classStructure := Obj classInstanceVariables.
	classStructure do: [ :key |
		elements add: (StrictlyOrderedEyeElement new 
								orderedStructure: classStructure;
								host: self object;
								index: key; 
								yourself)]
]
