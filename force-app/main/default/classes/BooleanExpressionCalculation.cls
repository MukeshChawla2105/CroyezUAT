public without sharing class BooleanExpressionCalculation {
    
    public static boolean evaluateExpression(String expression){
        expression = expression.toLowerCase(expression);
        system.debug('expression""'+expression);
        system.debug(expression.containsIgnoreCase('false')+'__'+expression.containsIgnoreCase('true'));
        if(expression.containsIgnoreCase('false') == false){ return true;}
        if(expression.containsIgnoreCase('true') == false){ return false;}
        expression = runeval(expression);
        if(expression == 'true') return true;
        return false;
    }
    
    public static string runeval(String expression){
        system.debug('expression::'+expression);
        if(expression.contains('true and true')||expression.contains('true and false')||expression.contains('false and true')||expression.contains('false and false')){
            expression = BooleanExpressionCalculation.replaceANDLogic(expression);
        }
        if(expression.contains('true or true')||expression.contains('true or false')||expression.contains('false or true')||expression.contains('false or false')){
            expression = BooleanExpressionCalculation.replaceORLogic(expression);
        }
        system.debug(expression+'___');   
        if(expression.contains('(true)')){     
            expression = replaceleftBrackets(expression);
        }
        if(expression.contains('(false)')){
            expression = replaceRightBrackets(expression);
        }
        system.debug(expression+'___');
        if(expression.contains('(')|| expression.contains(')') || 
           expression.contains('or')|| expression.contains('and')){
               expression = runeval(expression);
           }
        system.debug(expression+'___final');
        return expression;
    }
    
    public static string replaceleftBrackets(string expression){
        expression = expression.replaceAll('\\(true\\)', 'true');
        if(expression.contains('(true)')){
            expression = replaceRightBrackets(expression);
        }
        return expression;
    }
    
    public static string replaceRightBrackets(string expression){
        expression = expression.replaceAll('\\(false\\)', 'false');
        if(expression.contains('(false)')){
            expression = replaceRightBrackets(expression);
        }
        return expression;
    }
    
    public static string replaceANDLogic(String exp){
        exp = exp.replaceAll('true and true', 'true');
        exp = exp.replaceAll('false and true', 'false');
        exp = exp.replaceAll('true and false', 'false');
        exp = exp.replaceAll('false and false', 'false');
        if(exp.contains('true and true')||exp.contains('true and false')||exp.contains('false and true')||exp.contains('false and false')){
            exp = replaceANDLogic(exp);
        }        
        return exp;
    }
    
    public static string replaceORLogic(String exp){
        //exp = exp.toLowerCase(exp);
        //system.debug('exp::'+exp);
        exp = exp.replaceAll('true or true', 'true');
        exp = exp.replaceAll('false or true', 'true');
        exp = exp.replaceAll('true or false', 'true');
        exp = exp.replaceAll('false or false', 'false');
        if(exp.contains('true or true')||exp.contains('true or false')||exp.contains('false or true')||exp.contains('false or false')){
            system.debug('ayub___');
            exp = replaceORLogic(exp);
        }
        return exp;
    }
    
}