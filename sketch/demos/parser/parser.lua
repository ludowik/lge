-- grammar

grammar = {
    program = {
        'block'
    },

    block = {
        'statement_list'
    },

    statement_list = {
        'statement'
    },

    statement = {
        'statement_declare',
        'statement_assign',
        'statement_if',
        'statement_for',
        'statement_while',
        'statement_repeat',
    },

    statement_if = {
        {'if', 'expression', 'then', 'block', {'statement_elseif_list'}, {'statement_else'}, 'end'}
    },

    statement_elseif_list = {
        {'elseif', 'expression', 'then', 'block'}
    },

    statement_else = {
        {'else', 'expression', 'then', 'block'}
    },

    expression = {
        'factor'
    }
}
