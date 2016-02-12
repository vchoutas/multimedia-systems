function [q, n] = ihuff(b, s, debug)
%IHUFF Decodes the provided bitstream using the provided huffman code.
% B The bit stream that must be decoded.
% S A cell array containing the huffman code for each symbol.
% DEBUG A optional argument used for more verbose output and debugging.
% Q The decoded signal.
% N The number of bits remaining after the decoding procedure.
 
if nargin < 3
    debug = false;
end

if debug
    fprintf('Starting Huffman Decoding\n');
end
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
    if debug
        fprintf('Current Code Word is %s \n', currentCodeWord);
    end
    for k = 1:length(currentCodeWord)        
        if debug
            fprintf('Current character is %c \n', currentCodeWord(k));
        end
        if strcmp(currentCodeWord(k), '0')
            if debug
                fprintf('Right!\n');
            end
            % If the current bit is a zero then go to the right child
            % If it's empty then insert a new node in the tree.
            if isempty(root.rightChild)
                if debug
                    fprintf('Creating new right node!\n');
                end
                numNodes = numNodes + 1;

                huffmanTree{numNodes} = create_node(k, currentCodeWord, ...
                    root.id, numNodes, '0', i);
                huffmanTree{root.id}.rightChild = numNodes;
                
                % The root for the next iteration is the newly inserted
                % node.
                root = huffmanTree{numNodes};
            else
                root = huffmanTree{root.rightChild};
            end
        else
            if debug
                fprintf('Left!\n');
            end
            if isempty(root.leftChild)
                if debug
                    fprintf('Creating new left node!\n');
                end
                numNodes = numNodes + 1;
                huffmanTree{numNodes} = create_node(k, currentCodeWord, ...
                    root.id, numNodes, '1', i);
                
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
if debug
    for i = 1:length(huffmanTree)
        if isempty(huffmanTree{i}.symbol)
            continue
        end
        
        index = huffmanTree{i}.id;
        b = '';
        while (~isempty(huffmanTree{index}.parentId))
            b = [huffmanTree{index}.digit b];
            index = huffmanTree{index}.parentId;
        end
        fprintf('Code for symbol %d is %s \n', huffmanTree{i}.symbol, ...
            b);
    end
end


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

if debug
    fprintf('Finished Huffman Decoding! \n');
end
end