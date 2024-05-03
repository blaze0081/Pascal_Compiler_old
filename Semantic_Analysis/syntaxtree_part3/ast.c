#include "ast.h"
void bfs(Node *head)
{
    Node *arr[100];
    for (int i = 0; i < 100; i++) { 
        arr[i] = NULL; 
    } 
    arr[0]=head;
    int t=0;
    while(1)
    {
        int size=0;
        Node * temp[100];
        int x=0;
        while(arr[size]!=NULL)
        size++;
        for(int i=0; i<size; i++)
        {
            printf("%s ",arr[i]->name);
            for(int j=0; j< arr[i]->n; j++)
            temp[x++]=arr[i]->children[j];
        }
        printf("\n");
        for (int k = 0; k < 100; k++) { 
        arr[k] = NULL; 
        } 
        for(int i=0; i<x; i++)
        arr[i]=temp[i];
        if(x==0)
        break;
    }
}
void dfs_tree(Node * head ,FILE * fp)
{
    if(head==NULL)
    return;
    fputs("[",fp);
    fputs(head->name,fp);
    for(int i=0; i< head->n; i++)
    {
        dfs_tree(head->children[i],fp);
    }
    fputs("]",fp);
}
void dfs(Node * head)
{
    FILE *fp;
    fp = fopen("tree.txt", "w");

    dfs_tree(head,fp);
    fclose(fp);
}
void initialize(Node * head)
{
    head->n=0;
    for(int i=0; i<20; i++)
    head->children[i]=NULL;
    memset(head->name,0,30);
}
Node* createNode()
{
    Node * head= calloc(1,sizeof(Node));
    initialize(head);
    return head;
}
void addchild(Node * head,Node * child)
{
    head->children[head->n]=child;
    head->n++;
}
void setname(Node * head, char * str)
{
    strcpy(head->name,str);
}