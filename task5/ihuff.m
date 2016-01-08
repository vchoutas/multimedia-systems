function [q, n] = ihuff(b, s)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

N = length(s);

treeNode = struct('parentId', [], 'id', [], 'isLeaf', [], ...
    'leftChild', [], 'rightChild', [], 'symbol', [], 'digit', []);

% Initialize the Huffman Tree.
huffmanTree = {};


numNodes = 1;
huffmanTree{numNodes} = treeNode;
huffmanTree{numNodes}.isLeaf = false;
huffmanTree{numNodes}.id = numNodes;
% parent = numNode;
for i = 1 : N
    currentCodeWord = s{i};
    
    root = huffmanTree{1};
%     fprintf('Current Code Word is %s \n', currentCodeWord);
    for k = 1:length(currentCodeWord)        
        if strcmp(currentCodeWord(k), '0')
%             fprintf('Right!\n');
            % If the current bit is a zero then go to the right child
            % If it's empty then insert a new node in the tree.
            if isempty(root.rightChild)
%                 fprintf('Creating new right node!\n');
                numNodes = numNodes + 1;
                huffmanTree{numNodes} = treeNode;
                if (k == length(currentCodeWord))
                    huffmanTree{numNodes}.symbol = i;
                end
                huffmanTree{numNodes}.isLeaf = k == length(currentCodeWord);
                huffmanTree{numNodes}.parentId = root.id;
                huffmanTree{numNodes}.id = numNodes;
                huffmanTree{numNodes}.digit = '0';
                huffmanTree{root.id}.rightChild = numNodes;
                
                % The root for the next iteration is the newly inserted
                % node.
                root = huffmanTree{numNodes};
            else
                root = huffmanTree{root.rightChild};
            end
        else
%             fprintf('Left!\n');
            if isempty(root.leftChild)
%                 fprintf('Creating new left node!\n');
                numNodes = numNodes + 1;
                huffmanTree{numNodes} = treeNode;
                if (k == length(currentCodeWord))
                    huffmanTree{numNodes}.symbol = i;
                end
                huffmanTree{numNodes}.isLeaf = k == length(currentCodeWord);
                huffmanTree{numNodes}.parentId = root.id;
                huffmanTree{numNodes}.id = numNodes;
                huffmanTree{numNodes}.digit = '1';
                huffmanTree{root.id}.leftChild = numNodes;
                % The root for the next iteration is the newly inserted
                % node.
                root = huffmanTree{numNodes};
            else
                root = huffmanTree{root.leftChild};
            end
        end
    end
end

% TEST for code correctness.
% for i = 1:length(huffmanTree)
%     if isempty(huffmanTree{i}.symbol)
%         continue
%     end
%     
%     index = huffmanTree{i}.id;
%     b = '';
%     while (~isempty(huffmanTree{index}.parentId))
%         b = [huffmanTree{index}.digit b];
%         index = huffmanTree{index}.parentId;
%     end
%     fprintf('Code for symbol %d is %s \n', huffmanTree{i}.symbol, ...
%         b);
% end


q = [];
currentRoot = huffmanTree{1};
decoded = 0;
for i = 1:length(b)
    currentChar = b(i);
    % If we have reached a leaf node, reset the root of the current
    % subtree to the root of the Huffman Tree and append the symbol
    % that corresponds to this leaf node.
    if currentRoot.isLeaf
        q = [q; currentRoot.symbol];
        currentRoot = huffmanTree{1};
        decoded = i;
    end
    if strcmp(currentChar, '0')
        currentRoot = huffmanTree{currentRoot.rightChild};
    else
        currentRoot = huffmanTree{currentRoot.leftChild};
    end
end

if currentRoot.isLeaf
    q = [q; currentRoot.symbol];
    decoded = i;
end

n = length(b) - decoded;

fprintf('Finished Huffman Decoding! \n');

end