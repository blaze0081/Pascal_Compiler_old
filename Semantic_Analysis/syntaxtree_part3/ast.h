#ifndef AST_H
#define AST_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

typedef struct node{
    struct node* children[20];
    char name[30];
    int n;
    int ival;
    float fval;
}Node;
extern Node * myhead;
void bfs(Node* head);
void dfs(Node * head);
void addchild(Node * head,Node * child);
void setname(Node * head, char * str);
Node* createNode();
void initialize(Node * head);

// // for "if/else" statements
// struct ast_if_node{
	
//   struct ast_node *condition;
//   struct ast_node *if_branch;
//   struct ast_node *else_branch;
// };


// // for "while" statements
// struct ast_while_node{

//   struct ast_node *condition;
//   struct ast_node *stmts;
// };

// // for "for" statements
// struct ast_for_node{
// 	struct ast_node *init_condition;
// 	struct ast_node *end_condition;
// 	struct ast_node *for_branch;
// };


// // for constant or id nodes
// struct ast_leaf_node{

//   char *name;
//   Type_Struct *ts_value;
// };

// // for id nodes used in with statements
// struct ast_record_leaf_node{
	
// 	char *name;
// 	AST_node *record;
	
// 	Type_Struct *ts_value;
// };

// // for set nodes
// struct ast_set_list_node{

//   Type_Struct *ts_value;
// };


// struct ASTNode* createAssignmentNode(struct ast_leaf_node* identifier, struct ASTNode* expression1, struct ASTNode* expression2) {
//     struct ast_func_proc_node* node = malloc(sizeof(struct ast_func_proc_node));
//     node->type = ASSIGNMENT;
//     node->id_node = identifier;
//     node->arguments = expression1;
//     node->statements = expression2;
//     return (struct ASTNode*)node;
// }

#endif



