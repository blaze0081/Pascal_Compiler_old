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
    Node * head= (Node *)calloc(1,sizeof(Node));
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
void addentry(symboltable *t,char * identifier,int type)
{
    entry * temp = calloc(1,sizeof(entry));
    temp->type=type;
    strcpy(temp->name,identifier);
    t->table[t->n]=temp;
    t->n=t->n + 1;
}
void print_table(symboltable *t)
{
    for(int i=0; i<t->n; i++)
    {
        entry * temp= t->table[i];
        int type=temp->type;
        switch (type)
        {
        case 0:
            printf("%s\t\t\t\t%s\t%d\n",temp->name,"Integer",temp->ival);
            break;
        case 1:
            printf("%s\t\t\t\t%s\t%lf\n",temp->name,"Real",temp->fval);
            break;
        case 2:
            printf("%s\t\t\t\t%s\t%d\n",temp->name,"Boolean");
            break;
         case 3:
            printf("%s\t\t\t\t%s\n",temp->name,"Char");
            break;
         case 4:
            printf("%s\t\t\t\t%s\t%p\n",temp->name,"Integer_Array",&temp->arr);
            break;
         case 5:
            printf("%s\t\t\t\t%s\t%p\n",temp->name,"Real_Array",&temp->farr);
            break;
         case 6:
            printf("%s\t\t\t\t%s\t%p\n",temp->name,"Boolean_Array",&temp->arr);
            break;
         case 7:
            printf("%s\t\t\t\t%s\t%p\n",temp->name,"Char_Array",&temp->arr);
            break;
        default:
            break;
        }
    }
}
entry * lookup(symboltable *t,char *str)
{
    for(int i=0; i<t->n; i++)
    {
        if(!strcmp(t->table[i]->name,str))
        {
            return t->table[i];
        }
    }
}
void forto(symboltable *t,Node* head)
{
    char* lit=head->children[0]->name;
    int runi=1;
    int runl=0;
    if (!strcmp(head->children[1]->name,"ICONST")){
        runi=(head->children[1]->ival);
    }
    else{
        runi=lookup(t,head->children[1]->name)->ival;
    }
    if (!strcmp(head->children[2]->name,"ICONST")){
        runl=(head->children[2]->ival);
    }
    else{
        runl=lookup(t,head->children[2]->name)->ival;
    }
    int i=0;
    for (i=runi;i<=runl;i++){
        entry* tp=lookup(t,lit);
        tp->ival=i;
        rec_solve(t,head->children[3]);
    }
}
void while_handler(symboltable *t,Node* head)
{
    while(handlebval(t,head->children[0]))
    {
        rec_solve(t,head->children[1]);
    }
}
void fordown(symboltable *t,Node* head)
{
    char* lit=head->children[0]->name;
    int runi=1;
    int runl=0;
    if (!strcmp(head->children[1]->name,"ICONST")){
        runi=(head->children[1]->ival);
    }
    else{
        runi=lookup(t,head->children[1]->name)->ival;
    }
    if (!strcmp(head->children[2]->name,"ICONST")){
        runl=(head->children[2]->ival);
    }
    else{
        runl=lookup(t,head->children[2]->name)->ival;
    }
    int i=0;
    for (i=runi;i>=runl;i--){
        entry* tp=lookup(t,lit);
        tp->ival=i;
        rec_solve(t,head->children[3]);
    }
}
int handleival(symboltable *t,Node* head)
{
    char *str = head->name;
    if(!strcmp(str,"PLUS"))
    {
        return handleival(t,head->children[0])+handleival(t,head->children[1]);
    }
    else if(!strcmp(str,"MINUS"))
    {
        return handleival(t,head->children[0])-handleival(t,head->children[1]);
    }
    else if(!strcmp(str,"MULTIPLY"))
    {
        return handleival(t,head->children[0])*handleival(t,head->children[1]);
    }
    else if(!strcmp(str,"DIVISION"))
    {
        return handleival(t,head->children[0])/handleival(t,head->children[1]);
    }
    else if(!strcmp(str,"MODULUS"))
    {
        return handleival(t,head->children[0])%handleival(t,head->children[1]);
    }
    else if(!strcmp(str,"Expression"))
    {
        return handleival(t,head->children[1]);
    }
    else if(!strcmp(str,"Array_Access"))
    {
        char* aname=head->children[0]->name;
        entry *ttt=lookup(t,aname);
        if (!strcmp(head->children[1]->name,"ICONST")){
            return ttt->arr[head->children[1]->ival];
        }
        else{
            return ttt->arr[handleival(t, head->children[1])];
        }
    }
    else if(!strcmp(str,"ICONST")){
        return head->ival;
    }
    else
    {
        return lookup(t,str)->ival;
    }
}


float handlefval(symboltable *t,Node* head)
{
    char *str = head->name;
    if(!strcmp(str,"PLUS"))
    {
        return handlefval(t,head->children[0])+handlefval(t,head->children[1]);
    }
    else if(!strcmp(str,"MINUS"))
    {
        return handlefval(t,head->children[0])-handlefval(t,head->children[1]);
    }
    else if(!strcmp(str,"MULTIPLY"))
    {
        return handlefval(t,head->children[0])*handlefval(t,head->children[1]);
    }
    else if(!strcmp(str,"DIVISION"))
    {
        return (handlefval(t,head->children[0])*1.0)/(handlefval(t,head->children[1])*1.0);
    }
    else if(!strcmp(str,"Expression"))
    {
        return handlefval(t,head->children[1]);
    }
    else if(!strcmp(str,"Array_Access"))
    {
        char* aname=head->children[0]->name;
        entry *ttt=lookup(t,aname);
        if (!strcmp(head->children[1]->name,"ICONST")){
            return ttt->arr[head->children[1]->ival];
        }
        else{
            return ttt->arr[handleival(t, head->children[1])];
        }
    }
    else if(!strcmp(str,"RCONST")){
        return head->fval;
    }
    else if(!strcmp(str,"ICONST")){
        return head->fval;
    }
    else
    {
        return lookup(t,str)->fval;
    }
}
int handlebval(symboltable *t,Node* head)
{
    char *str = head->name;
    if(!strcmp(str,"EQUALS"))
    {
        return handleival(t,head->children[0])==handleival(t,head->children[1]);
    }
    else if(!strcmp(str,"NOT_EQUALS"))
    {
        return handleival(t,head->children[0])!=handleival(t,head->children[1]);
    }
    else if(!strcmp(str,"LESS_THAN"))
    {
        return handleival(t,head->children[0])<handleival(t,head->children[1]);
    }
    else if(!strcmp(str,"GREATER_THAN"))
    {
        return handleival(t,head->children[0])>handleival(t,head->children[1]);
    }
    else if(!strcmp(str,"LESS_THAN_EQUALS"))
    {
        return handleival(t,head->children[0])<=handleival(t,head->children[1]);
    }
    else if(!strcmp(str,"GREATER_THAN_EQUALS"))
    {
        return handleival(t,head->children[0])>=handleival(t,head->children[1]);
    }
    else if(!strcmp(str,"Expression"))
    {
        return handlebval(t,head->children[1]);
    }
    else if(!strcmp(str,"NOT"))
    {
        return !handlebval(t,head->children[1]);
    }
    else if(!strcmp(str,"AND"))
    {
        return handlebval(t,head->children[0])&handlebval(t,head->children[1]);
    }
    else if(!strcmp(str,"OR"))
    {
        return handlebval(t,head->children[0])|handlebval(t,head->children[1]);
    }
    else if(!strcmp(str,"Array_Access"))
    {
        char* aname=head->children[0]->name;
        entry *ttt=lookup(t,aname);
        if (!strcmp(head->children[1]->name,"ICONST")){
            return ttt->arr[head->children[1]->ival];
        }
        else{
            return ttt->arr[handleival(t, head->children[1])];
        }
    }
    else
    {
        return lookup(t,str)->ival;
    }
}
void assign_handle(symboltable *t,Node* head)
{
    char* lit=head->children[0]->name;
    //printf("%s\n",lit);
    entry* en=lookup(t,lit);
    int type=en->type;
    switch (type)
    {
    case 0:
        en->ival=handleival(t,head->children[1]);
        en->fval=en->ival;
        break;
    case 1:
        en->fval=handlefval(t,head->children[1]);
        break;
    case 2:
        en->ival=handlebval(t,head->children[1]);
        break;
    case 4:
        if(!strcmp(head->children[1]->name,"ICONST"))
        {
            en->arr[head->children[1]->ival]=handleival(t,head->children[2]);
        }
        else{
             en->arr[handleival(t,head->children[1])]=handleival(t,head->children[2]);
        }
        break;
    case 5:
        if(!strcmp(head->children[1]->name,"ICONST"))
        {
            en->arr[head->children[1]->ival]=handlefval(t,head->children[2]);
        }
        else{
             en->arr[handleival(t,head->children[1])]=handlefval(t,head->children[2]);
        }
        break;
    case 6:
        if(!strcmp(head->children[1]->name,"ICONST"))
        {
            en->arr[head->children[1]->ival]=handleival(t,head->children[2]);
        }
        else{
             en->arr[handleival(t,head->children[1])]=handleival(t,head->children[2]);
        }
        break;
    default:
        break;
    }
}
void handleit(symboltable *t,Node* head)
{
    if(handlebval(t,head->children[0]))
    rec_solve(t,head->children[1]);
}
void handleite(symboltable *t,Node* head)
{
    if(handlebval(t,head->children[0]))
    rec_solve(t,head->children[1]);
    else
    rec_solve(t,head->children[2]);
}
void rec_solve(symboltable *t,Node* head)
{
    for(int i=0; i<head->n; i++)
    {
        Node * child= head->children[i];
        if(!strcmp(child->name,"FORTO"))
        {
            forto(t,child);
        }
        else if(!strcmp(child->name,"FORDOWNTO"))
        {
            fordown(t,child);
        }
        else if(!strcmp(child->name,"WHILE"))
        {
            while_handler(t,child);
        }
        else if(!strcmp(child->name,"Assign"))
        {
            assign_handle(t,child);
        }
        else if(!strcmp(child->name,"Branch"))
        {
            if(child->n==2)
            handleit(t,child);
            else
            handleite(t,child);
        }
        else if(!strcmp(child->name,"Write"))
        {
            if(!strcmp(child->children[0]->name,"STRING_LITERAL"))
            {
                child=child->children[0];
                int i=1;
                while(child->children[0]->name[i]!='"')
                {
                    printf("%c",child->children[0]->name[i]);
                    i++;
                }
                //printf("\n");
            }
            else
            {
                child=child->children[0];
                for(int i=0; i<child->n; i++)
                {
                    entry*temp;
                    int val=0;
                    if(!strcmp(child->children[i]->name,"Array_Access"))
                    {
                        temp=lookup(t,child->children[i]->children[0]->name);
                        val=handleival(t,child->children[i]->children[1]);
                    }
                    else
                    temp=lookup(t,child->children[i]->name);
                    switch (temp->type)
                    {
                    case 0:
                        printf("%d ",temp->ival);
                        break;
                    case 1:
                        printf("%lf ",temp->fval);
                        break;
                    case 2:
                        printf("%d ",temp->ival);
                        break;

                    case 4:
                        printf("%d ",temp->arr[val]);
                        break;
                    case 5:
                        printf("%f ",temp->farr[val]);
                        break;
                    case 6:
                        printf("%d ",temp->arr[val]);
                        break;
                    default:
                        break;
                    }
                }
                //printf("\n");
            }
        }
        else if(!strcmp(child->name,"READ"))
        {
            child=child->children[0];
            entry*temp;
                    int val=0;
                    if(!strcmp(child->name,"Array_Access"))
                    {
                        temp=lookup(t,child->children[0]->name);
                        val=handleival(t,child->children[1]);
                    }
                    else
                    temp=lookup(t,child->name);
            switch (temp->type)
                    {
                    case 0:
                        scanf("%d",&temp->ival);
                        break;
                    case 1:
                        scanf("%f",&temp->fval);
                        break;
                    case 2:
                        scanf("%d",&temp->ival);
                        break;
                    
                    case 4:
                        scanf("%d",&temp->arr[val]);
                        break;
                    case 5:
                        scanf("%f",&temp->farr[val]);
                        break;
                    case 6:
                        scanf("%d",&temp->arr[val]);
                        break;
                    default:
                        break;
                    }
        }
    }
}
void solve(symboltable *t,Node* head)
{
    head=head->children[1];
    rec_solve(t,head);
}
