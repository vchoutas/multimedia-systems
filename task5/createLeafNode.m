function outputNode = createLeafNode( input_args )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

persistent treeNode
if isempty(treeNode)
    treeNode = struct('parentId', [], 'Id', [], 'isLeaf', [], ...
        'leftChild', [], 'rightChild', []);
end

end

