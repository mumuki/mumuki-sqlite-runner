\c mumuki;

CREATE TABLE public.test (
    id bigserial primary key,
    name varchar(200) NOT NULL
);

INSERT INTO public.test (name) values ('Testing1');
INSERT INTO public.test (name) values ('Testing2');
INSERT INTO public.test (name) values ('Testing3');