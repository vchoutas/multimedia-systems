function outputNode = create_node(k, currentCodeWord, parentId, nodeId,...
    digit, symbol)
%CREATE_NODE Creates a node for the huffman tree.
% K The index for the current bit being processed
% CURRENTCODEWORD The current code word that is used to create the huffman
% tree
% PARENTID The id for the parent node for the node we are about to create.
% NODEID The desired id for the node that will be created
% DIGIT The bit, 0 or 1, that will be assigned to this node.
% SYMBOL The corresponding symbol if this is a leaf node.

persistent treeNode
if isempty(treeNode)
    treeNode = struct('parentId', [], 'Id', [], 'isLeaf', [], ...
        'leftChild', [], 'rightChild', []);
end

outputNode = treeNode;

outputNode.isLeaf = k == length(currentCodeWord);
if outputNode.isLeaf
    outputNode.symbol = symbol;
end
outputNode.parentId = parentId;
outputNode.id = nodeId;
outputNode.digit = digit;

end

