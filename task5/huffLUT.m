function [s] = huffLUT(p)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

% sortedProbs = sort(p, 'ascend');
% initWeightQueue = sortedProbs;
% combinedWeightQueue = [];

s = {};
N = length(p);
numSymbols = floor(log2(N)) + 1;

treeNode = struct('parentId', [], 'prob', [], 'Id', [], 'isLeaf', []);

idVector = 1:N;
idVector = idVector(:);
% huffmanTree = struct('parentId', zeros(N, 1), 'prob', p, 'id', idVector, ...
%     'isLeaf', true(N, 1));
% 
% 
% pause

% Initialize the Huffan Tree.
huffmanTree = {};
for i = 1 : N
    huffmanTree{i} = treeNode;
    % Assign the probability of the node
    huffmanTree{i}.prob = p(i);
    % Assign the id of the node.
    huffmanTree{i}.id = i;
    % All initial nodes are leaves.
    huffmanTree{i}.isLeaf = true;
    % Don't assign the digit until the tree construction begins.
    huffmanTree{i}.digit = '';
end
% numLeaves = 

% Create the initial priority queue for the Huffman code construction
% using all the initial points.
priorityQueue = huffmanTree;

% Initialize the number of nodes. 
numNodes = N;
% [m, i] = min(arrayfun(@(i) priorityQueue{i}.prob, 1:numel(priorityQueue)))

while (length(priorityQueue) > 1)
    % Find the node with the smallest probability in the queue.
    [~, ind1] = min(arrayfun(@(i) priorityQueue{i}.prob, ...
        1:numel(priorityQueue)));
    firstNode = priorityQueue{ind1};
    % Remove the current element from the queue.
    priorityQueue(ind1) = [];
    % Find the node with the second smallest probability in the queue.
    [~, ind2] = min(arrayfun(@(i) priorityQueue{i}.prob, ...
        1:numel(priorityQueue)));
    secondNode = priorityQueue{ind2};
    % Remove the current element from the queue.
    priorityQueue(ind2) = [];

    % Increment the number of nodes.
    numNodes = numNodes + 1;
    
    % Create new node.
    huffmanTree{numNodes} = treeNode;
    % The probability of the new node is the sum of probabilities of
    % its two childern.
    huffmanTree{numNodes}.prob = firstNode.prob + secondNode.prob;
    huffmanTree{numNodes}.id = numNodes;
    huffmanTree{numNodes}.isLeaf = false;
    huffmanTree{numNodes}.digit = '';

    huffmanTree{firstNode.id}.digit = '1';  
    huffmanTree{secondNode.id}.digit = '0';
    
    huffmanTree{firstNode.id}.parentId = numNodes;
    huffmanTree{secondNode.id}.parentId = numNodes;
    
    priorityQueue{end + 1} = huffmanTree{numNodes};
end

s = cell(N, 1);
for i=1:N
    index = huffmanTree{i}.id;
    s{i} = '';
    while (~isempty(huffmanTree{index}.parentId))
        s{i} = [huffmanTree{index}.digit s{i}];
        index = huffmanTree{index}.parentId;
    end
    
end

symbols = [1:N];

[dict, avglen] = huffmandict(symbols, p);

for i = 1:length(dict)
    trueCode = '';
    for j=1:length(dict{i, 2})
        trueCode = [trueCode sprintf('%d', dict{i, 2}(j))];
    end
    
    if (~strcmp(trueCode, s{i}))
        fprintf('ERROR for symbol %d \n', i);
        fprintf('True: %s vs Ours : %s \n', trueCode, ...
            s{i});
        fprintf('Symbol Probability %f \n', huffmanTree{i}.prob);
        pause
        break
    end
end

end

