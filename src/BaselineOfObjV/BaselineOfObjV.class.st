Class {
	#name : #BaselineOfObjV,
	#superclass : #BaselineOf,
	#category : #BaselineOfObjV
}

{ #category : #baselines }
BaselineOfObjV >> baseline: spec [
	<baseline>
	spec for: #'pharo' do: [ spec package: 'ObjV' ]
]
