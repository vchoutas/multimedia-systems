function outputNode = createInnerNode(id)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

persistent treeNode
if isempty(treeNode)
    treeNode = struct('parentId', [], 'Id', [], 'isLeaf', [], ...
        'leftChild', [], 'rightChild', []);
end

outputNode = treeNode;
outputNode.isLeaf = false;
outputNode.id = id;
    
end

