Class {
	#name : #StrictlyOrderedEyeElement,
	#superclass : #BasicIndexedEyeElement,
	#type : #variable,
	#instVars : [
		'orderedStructure'
	],
	#category : #'ObjV-Inspector'
}

{ #category : #accessing }
StrictlyOrderedEyeElement >> orderedStructure [
	
	^ orderedStructure
]

{ #category : #accessing }
StrictlyOrderedEyeElement >> orderedStructure: anObject [
	
	orderedStructure := anObject
]

{ #category : #accessing }
StrictlyOrderedEyeElement >> value [
	^ self host basicAt: (self orderedStructure indexOf: index)
]
