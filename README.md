# LinkedList

A double linked list value type, implementing all standard Swift Collection protocols apart from RandomAccessCollection.

List sorting is provided via an iterative merge sort algorithm.

A default list node is provided for working with generic element types, or LinkedList.Node can be subclassed to provide custom list nodes (e.g., class CustomNode: LinkedList<CustomNode>.Node {} ).
